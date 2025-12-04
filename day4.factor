USING: arrays assocs hash-sets io io.encodings.utf8 io.files
kernel math math.vectors prettyprint sequences sets ;
IN: day4

:: hash-grid ( seq -- grid )
  seq [ first length ] [ length ] bi *
  <hash-set> :> grid
  seq [ [ 2array swap CHAR: @ = [ grid adjoin ] [ drop ] if ] curry each-index ] each-index
  grid ;

:: count-neighbours ( key grid -- n )
  { { -1 -1 } { -1 0 } { -1 1 } { 0 -1 } { 0 1 } { 1 -1 } { 1 0 } { 1 1 } }
  [ key v+ grid in? ] count ;

:: filter-grid ( grid -- grid' )
grid [ members [ grid count-neighbours 4 < ] filter dup empty? ]
[ grid swap diff! ] until drop grid ;

"day4.in" utf8 file-lines
hash-grid
[ [ members ] keep [ count-neighbours 4 < ] curry count ]
[ [ cardinality ] [ filter-grid cardinality ] bi - ] bi