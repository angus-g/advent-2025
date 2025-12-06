USING: io.encodings.utf8 io.files kernel math.parser
math.vectors sequences sequences.extras splitting strings
unicode ;
IN: day6

: find-splits ( seq -- seq' )
  [ [ 32 = ] { } map-as ] map
  unclip [ vand ] reduce t indices* ;

: parse-op ( str -- q ) "*" = [ product ] [ sum ] ? ;
: parse-ops ( seq -- seq ) [ [ blank? ] trim parse-op ] map ;

: from-columns ( seq -- seq )
  flip [ flip [ >string ] map ] map
  [ [ [ blank? ] trim ] [ empty? not ] map-filter ] map ;

! part 1
"day6.in" utf8 file-lines
dup find-splits
[ split-indices ] curry map
unclip-last

[ [ [ [ blank? ] trim string>number ] map ] map flip ]
[ parse-ops ] bi*

[ call( seq -- n ) ] 2map
sum

! part 2
"day6.in" utf8 file-lines
dup find-splits
[ split-indices ] curry map
unclip-last

[ from-columns [ [ string>number ] map ] map ]
[ parse-ops ] bi*

[ call( seq -- n ) ] 2map
sum
