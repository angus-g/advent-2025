USING: arrays columns formatting kernel math math.matrices
math.parser math.vectors prettyprint ranges sequences
sequences.extras sets splitting ;
IN: day10-2

! minimise c^T x, where Ax = b
! c is a vector of all ones, so we're minimising the l1-norm
! A is an mxn matrix where n > m
!
! example:
!
! ⎡0 0 0 0 1 1⎤   ⎡x1⎤   ⎡3⎤
! ⎢0 1 0 0 0 1⎥ * ⎢x2⎥ = ⎢5⎥
! ⎢0 0 1 1 1 0⎥   ⎢x3⎥   ⎢4⎥
! ⎣1 1 0 1 0 0⎦   ⎢x4⎥   ⎣7⎦
!                 ⎢x5⎥
!                 ⎣x6⎦
!
! we convert this to a non-canonical tableau
!
! ⎡1 │ -1 -1 -1 -1 -1 -1 │ 0⎤
! ⎢0 │  0  0  0  0  1  1 │ 3⎥
! ⎢0 │  0  1  0  0  0  1 │ 5⎥
! ⎢0 │  0  0  1  1  1  0 │ 4⎥
! ⎣0 │  1  1  0  1  0  0 │ 7⎦
!       ^     ^
!       B     B
!
! note that two columns already belong to a basic feasible point,
! but we must add two additional variables to construct the
! basic feasible point, by augmenting the tableau
!
! ⎡1 │ 0  0  0  0  0  0  0 │ -1 -1 │ 0⎤
! ⎢0 │ 1 -1 -1 -1 -1 -1 -1 │  0  0 │ 0⎥
! ⎢0 │ 0  0  0  0  0  1  1 │  1  0 │ 3⎥
! ⎢0 │ 0  0  1  0  0  0  1 │  0  1 │ 5⎥
! ⎢0 │ 0  0  0  1  1  1  0 │  0  0 │ 4⎥
! ⎣0 │ 0  1  1  0  1  0  0 │  0  0 │ 7⎦
!
! these values correspond to the right hand side, so we must
! add them to the first row
!
! ⎡1 │ 0  0  1  0  0  1  2 │  0  0 │ 8⎤
! ⎢0 │ 1 -1 -1 -1 -1 -1 -1 │  0  0 │ 0⎥
! ⎢0 │ 0  0  0  0  0  1  1 │  1  0 │ 3⎥
! ⎢0 │ 0  0  1  0  0  0  1 │  0  1 │ 5⎥
! ⎢0 │ 0  0  0  1  1  1  0 │  0  0 │ 4⎥
! ⎣0 │ 0  1  1  0  1  0  0 │  0  0 │ 7⎦
!
! now we need a submatrix of the original problem to be the identity matrix
! choose a pivot column and a pivot row within that column
! we have rows 3 and 4 of the identity in the basic set already,
! so choose column 2 and set the pivot row to row 2
!
! ⎡1 │ 0  0  0  0  0  1  1 │  0 -1 │ 3⎤
! ⎢0 │ 1 -1  0 -1 -1 -1  0 │  0  1 │ 5⎥
! ⎢0 │ 0  0  0  0  0  1  1 │  1  0 │ 3⎥
! ⎢0 │ 0  0  1  0  0  0  1 │  0  1 │ 5⎥
! ⎢0 │ 0  0  0  1  1  1  0 │  0  0 │ 4⎥
! ⎣0 │ 0  1  0  0  1  0 -1 │  0 -1 │ 2⎦
!
! and similarly, pivot on column 5, row 1
!
! ⎡1 │ 0  0  0  0  0  0  0 │ -1 -1 │ 0⎤
! ⎢0 │ 1 -1  0 -1 -1  0  1 │  1  1 │ 8⎥
! ⎢0 │ 0  0  0  0  0  1  1 │  1  0 │ 3⎥
! ⎢0 │ 0  0  1  0  0  0  1 │  0  1 │ 5⎥
! ⎢0 │ 0  0  0  1  1  0 -1 │ -1  0 │ 1⎥
! ⎣0 │ 0  1  0  0  1  0 -1 │  0 -1 │ 2⎦
!
! the artificial variables are now 0 and may be dropped to recover a
! canonical tableau equivalent to the original problem
!
! ⎡1 -1  0 -1 -1  0  1 │ 8⎥
! ⎢0  0  0  0  0  1  1 │ 3⎥
! ⎢0  0  1  0  0  0  1 │ 5⎥
! ⎢0  0  0  1  1  0 -1 │ 1⎥
! ⎣0  1  0  0  1  0 -1 │ 2⎦
!
! eliminate from the first row from basic variables
!
! ⎡1  0  0 -1  0  0  0 │ 10⎥
! ⎢0  0  0  0  0  1  1 │  3⎥
! ⎢0  0  1  0  0  0  1 │  5⎥
! ⎢0  0  0  1  1  0 -1 │  1⎥
! ⎣0  1  0  0  1  0 -1 │  2⎦
!
! ⎡1  0  0  0  1  0 -1 │ 11⎥
! ⎢0  0  0  0  0  1  1 │  3⎥
! ⎢0  0  1  0  0  0  1 │  5⎥
! ⎢0  0  0  1  1  0 -1 │  1⎥
! ⎣0  1  0  0  1  0 -1 │  2⎦
!
! now we have a positive entry, so pivot on column 4
! row 3
!
! ⎡1  0  0 -1  0  0  0 │ 10⎥
! ⎢0  0  0  0  0  1  1 │  3⎥
! ⎢0  0  1  0  0  0  1 │  5⎥
! ⎢0  0  0  1  1  0 -1 │  1⎥
! ⎣0  1  0 -1  0  0 -2 │  1⎦
!
!
!
! this leads to a formulation of the algorithm
!
! 1. construct the non-canonical tableau corresponding to the problem
! 2. determine which columns (if any) are already part of the basic
!    feasible solution, and note the rows associated with these
! 3. for each row not yet in the feasible solution, add an auxiliary
!    variable, and construct the augmented tableau
! 4. add the augmented rows to the first row of the tableau to
!    satisfy the equality constraint
! 5. while the auxiliary variables are non-zero:
!    a) choose a column in the non-basic set with a
!       corresponding pivot row
!    b) pivot to eliminary the auxiliary variable, and add the
!       column to the basic set
! 6. drop the augmentation from the tableau
! 7. fully pivot on all columns in the basic set, as required
!    (i.e. ensure all other rows in these columns are 0)
! 8. continue to pivot on any columns with a positive entry
!    in the objective function
! 9. read solution from top row of tableau

! implementation

: unclip-ends ( seq -- last mid first )
  unclip [ unclip-last swap ] dip ;

: fill-column ( seq n -- col )
  <iota> swap [ member? 1 0 ? ] curry map ;

: parse-seq ( str -- seq )
  unclip-ends drop nip "," split [ string>number ] map ;

: parse-matrix ( seq -- A )
  unclip length 2 -
  [ [ parse-seq ] dip fill-column ] curry map flip ;

: parse-line ( str -- A b )
  " " split
  unclip-last
  [ parse-matrix ] [ parse-seq ] bi* ;

: identity-col ( n rows -- col )
  <iota> [ = 1 0 ? ] with map ;

: identity-col? ( matrix n -- idx/? )
  over dimension second identity-col
  swap [ sequence= ] with find drop ;

! fill the index set corresponding to constraint matrix
! A with indices of columns of the indentity matrix
: basic-indices ( A -- idx )
  <flipped> dup dimension second ! number of rows
  <iota> [ identity-col? ] with map ;

! the first row contains { 1 -1 ... -1 0 }
! prepend 0 to all rows of A
! and append entries of b
: build-tableau ( A b -- tableau )
  over dimension second -1 <array> { 1 } { 0 } surround
  [ [ 0 [ suffix ] dip prefix ] 2map ] dip
  prefix ;

! columns are { -1 0 <identity(n)> }
: basic-cols ( idx -- cols )
  [ length ] keep
  [ rot
    [ 2drop { } ]
    [ swap identity-col { -1 0 } prepend ] if
  ] with map-index harvest ;

! return a sequence the same length as seq, where
! f elements are increasing integers from 0
! and t elements are now f
: count-gaps ( seq -- seq )
  dup 0 [ [ 1 + ] unless ] accumulate nip
  [ swap [ drop f ] when ] 2map ;

: append-cols ( tableau cols -- tableau )
  flip [ [ unclip-last ] dip swap [ append ] dip suffix ] 2map ;

! prefix all rows with 0
! add the first row for the augmented problem
: embed-tableau ( tableau -- tableau )
  [ 0 prefix ] map
  dup dimension second 1 - 0 <array> 1 prefix
  prefix ;

! insert identity columns corresponding to the f entries of
! idx before the last column
! then the first row is { 1 0 ... 0 -1 ... -1 0 }
! and again prepend all rows with 0
: augment-tableau ( idx tableau -- augmented idx' )
  ! build the auxiliary columns for the basic feasible solution
  swap [ basic-cols [ dup dimension second 2 - ] dip ] keep swapd
  [ [ embed-tableau ] dip append-cols ]
  [
    [ count-gaps [ [ + ] [ drop f ] if* ] with map ] keep
    [ or ] 2map
  ] 2bi*
  ! XXX add augmented rows to first row
  ;

! get the next position in the index set corresponding to an auxiliary variable
: next-auxiliary ( idx n -- n/f )
  [ >= ] curry find drop ;

! find a column in the non-basic set with index i non-zero
! requires an augmented tableau
! columns [ 2..cols(tableau)-1 ) \ idx
:: pivot-column-augmented ( tableau idx n -- col )
  tableau dimension second 3 - [0..b) idx diff :> nonbasic
  nonbasic 2 v+n tableau <flipped> nths
  n 2 + [ swap nth 1 = ] curry find drop
  nonbasic nth ;

! entry is a pair of { row-idx pivot-value }
: eliminate-row ( tableau entry pivot-idx -- tableau )
  [ first2 ] dip ! ( tableau elim-idx pivot-value pivot-idx -- )
  reach nth [ swap ] 2dip swap ! ( elim-idx tableau pivot-row pivot-value
  [ v*n v- ] 2curry [ tuck ] dip change-nth ;

: do-pivot-augmented ( tableau pivot-col pivot-row -- tableau )
  over "augmented pivot col: %d\n" printf
  [ 2 + ] bi@ ! adjust pivot row and col to the actual location in the tableau
  [ dupd <column> [ over zero? [ 2drop f ] [ swap 2array ] if ] map-index [ ] filter ] dip
  [ [ swap first = ] curry reject ] keep ! ( tableau row-indices pivot-row )
  [ eliminate-row ] curry swapd reduce ;

"[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}"
parse-line
[ dup basic-indices ] dip swapd
build-tableau
[ nip dimension second 2 - ] 2keep ! save original problem size
augment-tableau
dup reach next-auxiliary [
  ! find a pivot column
  [ 2dup ] dip [ pivot-column-augmented ] keep
  [ swap set-nth-of ] 2keep ! update index set
  [ swapd ] dip ! tuck idx under our working set
  do-pivot-augmented
] when*
.