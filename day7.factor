USING: arrays io.encodings.utf8 io.files kernel math sequences
sequences.deep sets ;
IN: day7

: find-splitters ( line -- seq )
CHAR: ^ swap indices ;

:: do-split ( splits beams line -- count' beams' )
  beams
  line find-splitters
  [ [ member? ] curry count ]
  [ [ dupd member? [ [ 1 - ] [ 1 + ] bi 2array ] [ 1array ] if ] curry map flatten members ] 2bi
  [ splits + ] dip ;

: count-splits ( map beams -- splits )
 [ 0 ] 2dip [ do-split ] reduce drop ;

MEMO: count-paths ( map beam -- paths )
  over empty? [ 2drop 1 ] [
    [ unclip ] dip swap find-splitters ! ( rest beam splitters )
    dupd member? ! ( rest beam ? )
    [ [ 1 + count-paths ] [ 1 - count-paths ] 2bi + ] [ count-paths ] if
  ] if ;

"day7.in" utf8 file-lines
unclip
CHAR: S swap index
[ 1array count-splits ] [ count-paths ] 2bi
