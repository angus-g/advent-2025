USING: accessors arrays assocs binary-search grouping
io.encodings.utf8 io.files kernel math math.order math.parser
math.rectangles math.vectors quadtrees sequences
sequences.extras sorting splitting ;
IN: day9

"day9.in" utf8 file-lines
[ "," split [ string>number ] map ] map
dup
[ v- vabs { 1 1 } v+ first2 * ] cartesian-map
[ maximum ] maximum-by maximum

:: <generic-rect> ( a b -- rect )
  a first b first min
  a second b second min 2array
  a first b first max
  a second b second max 2array
  <extent-rect> ;

: tiles ( points -- quadtree )
  dup
  [ [ [ first ] minimum-by first ] [ [ second ] minimum-by second ] bi 2array ]
  [ [ [ first ] maximum-by first ] [ [ second ] maximum-by second ] bi 2array ] bi
  <extent-rect> <quadtree> tuck
  [ dupd set-at ] curry each ;

: poly-edges ( points -- edges )
  dup first suffix
  2 clump
  [ first2 <generic-rect> ] map
  [ rect-extent drop first ] sort-by ;

: rect-shrink ( rect -- rect )
  rect-extent
  [ { 1 1 } v+ ] [ { 1 1 } v- ] bi* <extent-rect> ;

:: tile-size ( a b quadtree -- n )
  a b <generic-rect>
  rect-shrink
  quadtree in-rect length ;

: filter-edges ( pt edges -- edge-slice )
  tuck [ first ] dip
  [ rect-extent drop first <=> ] with search drop
  tail-slice ;

:: on-edge? ( pt edges -- ? )
  pt edges
  [ contains-point? ] with any? ;

:: inside-winding? ( pt quadtree edges -- ? )
  pt
  quadtree bounds>> rect-extent nip first
  pt second 2array
  <generic-rect> :> ray
  pt edges filter-edges
  [ ray contains-rect? ] count odd? ;

! point is inside if it's on an edge, or completely inside and has odd winding
:: inside? ( pt quadtree edges -- ? )
  pt edges on-edge?
  [ pt quadtree edges inside-winding? ] unless* ;

! check that all four corners are inside the polygon
:: corners-inside? ( a' b' quadtree edges -- seq? )
  a' first b' first min
  a' second b' second min 2array :> a
  a' first b' first min
  a' second b' second max 2array :> b
  a' first b' first max
  a' second b' second min 2array :> c
  a' first b' first max
  a' second b' second max 2array :> d

  { a b c d } [ quadtree edges inside? ] map ;

:: middle-inside? ( a b quadtree edges -- ? )
  a b <generic-rect>
  rect-bounds 2 v/n v+
  quadtree edges inside-winding? ;

:: no-intersections? ( a b edges -- ? )
  a b <generic-rect> rect-shrink
  edges [ contains-rect? ] with none? ;

:: tile-valid? ( a b quadtree edges -- ? )
  ! polygon contains no other points
  a b quadtree tile-size zero? not
  ! centre of the rectangle is in the polygon
  [ a b quadtree edges middle-inside? not ] unless*
  ! shrunken centre doesn't intersect any edges
  [ a b edges no-intersections? not ] unless*
  ! all corners are on/in the polygon
  [ a b quadtree edges corners-inside? [ ] all? not ] unless* not ;

:: valid-tile-size ( a b quadtree edges -- n )
  a b quadtree edges tile-valid?
  [ a b <generic-rect> rect-bounds nip { 1 1 } v+ first2 * ] [ 0 ] if ;

"day9.in" utf8 file-lines
[ "," split [ string>number ] map ] map
dup [ tiles ] [ poly-edges ] bi
[ valid-tile-size ] 2curry dupd cartesian-map
[ maximum ] maximum-by maximum