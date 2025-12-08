USING: accessors arrays assocs disjoint-sets io.encodings.utf8
io.files kernel math math.parser math.vectors sequences
sequences.deep sets sorting splitting ;
IN: day8

! One-sided cartesian product, with one level of flattening to return
! to a sequence of pairs

: perms ( seq -- seq )
  dup [ swap 1 + tail [ 2array ] with map ] curry map-index flatten1 ;

! The default add-atoms will nuke any existing definitions, so we add
! a conditional variant

: add-atoms? ( seq disjoint-set -- )
  [ 2dup disjoint-set-member? [ 2drop ] [ add-atom ] if ] curry each ;

:: make-circuits ( pairs -- circuits )
  <disjoint-set> :> circuits
  pairs [ circuits [ add-atoms? ] [ equate-all ] 2bi ] each
  circuits ;

! This is a bit of a roundabout way of getting the equivalence
! set sizes:
! 1. get everything in the set;
! 2. get the representative element for each (i.e. the top of the forest);
! 3. de-duplicate the set of representatives;
! 4. get the set size for each

: circuit-sizes ( circuits -- seq )
  [ disjoint-set-members ] keep
  [ [ representative ] curry map members ] keep
  [ equiv-set-size ] curry map ;

:: find-connection ( n pairs -- pair )
  <disjoint-set> :> circuits
  pairs [| pair |
    pair circuits [ add-atoms? ] [ equate-all ] 2bi
    pair first circuits equiv-set-size n =
  ] find nip ;

: part1 ( perms -- n )
  1000 head
  make-circuits
  circuit-sizes inv-sort 3 head product ;

: part2 ( n perms -- n )
  find-connection first2 v* first ;

"day8.in" utf8 file-lines
[ length ] keep
[ "," split [ string>number ] map ] map
perms
[ first2 distance ] sort-by

[ nip part1 ] [ part2 ] 2bi

