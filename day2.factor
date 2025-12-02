USING: grouping io.encodings.utf8 io.files kernel math
math.parser ranges sequences splitting unicode ;
IN: day2

: invalid ( n -- ? ) number>string dup length 2 /i cut = ;

: digit-splits ( n -- seq )
  length [ 1 - [1..b] ] keep [ swap mod zero? ] curry filter ;
: invalid2 ( n -- ? ) number>string [ digit-splits ] keep [ swap group unclip [ = ] curry [ and ] map-reduce ] curry any? ;

"day2.in" utf8 file-contents
[ blank? ] trim-tail

"," split
[ "-" split [ string>number ] map first2 [a..b] ] map

[ [ [ invalid ] filter ] map concat sum ]
[ [ [ dup number>string length 1 > [ invalid2 ] [ drop f ] if ] filter ] map concat sum ]
bi
