USING: arrays binary-search io.encodings.utf8 io.files kernel
math math.order math.parser sequences sorting splitting ;
IN: day5

: in-range? ( a b n -- ? )
[ <= ] [ >= ] bi-curry bi* and ;

: fresh ( n ranges -- ? )
  swap
  [ [ "-" split [ string>number ] map first2 ] dip in-range? ] curry find drop ;

:: do-merge ( i ranges -- ranges' )
  ranges first first
  i ranges nth second ranges first second max
  2array
  ranges i 1 + tail
  swap prefix ;

:: find-merge ( ranges -- ranges' )
  ranges length 1 <= [ ranges ]
  [
    ranges dup
    first second
    [ [ first ] dip >=< ] curry search drop
    dup zero? [ drop ranges unclip [ find-merge ] dip prefix ]
    [
      ranges do-merge find-merge
    ] if
  ] if ;

:: merge-ranges ( a b -- seq )
  b first a second [ = ] [ - 1 = ] 2bi or [ a first b second 2array 1array ] [ a b 2array ] if ;

: merge-adjacent ( ranges -- ranges' )
  dup length 1 <= [ ]
  [
    2 cut [ first2 merge-ranges ] dip append
    unclip [ merge-adjacent ] dip prefix
  ] if ;

: range-len ( range -- n ) first2 swap - 1 + ;

: part1 ( input -- n )
  first2
  [ string>number ] map
  swap [ fresh ] curry count ;

: part2 ( input -- n )
  first
  [ "-" split [ string>number ] map ] map sort
  [| orig | orig find-merge merge-adjacent dup orig = ] [ ] until
  [ range-len ] map sum ;

"day5.in" utf8 file-lines
{ "" } split
[ part1 ] [ part2 ] bi
