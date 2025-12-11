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

: parse-matrix ( seq -- A ) ;

: parse-goal ( str -- b );

: build-tableau ( A b -- tableau ) ;

! parse a line with format
! [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
! into a non-canonical tableau
: parse-line ( str -- tableau )
  " " split
  unclip-ends
  [ drop ] [ parse-matrix ] [ parse-goal ] tri*
  build-tableau ;
