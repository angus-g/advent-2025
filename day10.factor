USING: arrays deques dlists io.encodings.utf8 io.files kernel
math math.parser sequences sequences.extras splitting ;
IN: day10

: unclip-ends ( seq -- last mid first )
  unclip [ unclip-last swap ] dip ;

: parse-button ( str -- n )
  unclip-ends drop nip
  "," split [ string>number ] map
  [ 1 swap shift + ] 0reduce ;

: parse-line ( str -- buttons target nbits )
  " " split
  unclip-ends
  [ drop ]
  [ [ parse-button ] map ]
  [ unclip-ends drop nip
    [ [ CHAR: # = 1 0 ? ] { } map-as reverse 2 base-digits> ]
    [ length ] bi
  ] tri* ;

:: bfs ( buttons target nbits -- n )
  <dlist> :> queue
  nbits 2^ f <array> :> seen
  0 0 2array queue push-front
  [ queue peek-back first target = ]
  [
    queue pop-back :> current
    t current first seen set-nth
    current second 1 + :> n
    buttons current first [ bitxor ] curry map
    [ seen nth ] [ n 2array ] reject-map
    queue push-all-front
  ] until
  queue peek-back second ;

: process-line-lights ( line -- n )
  parse-line bfs ;

"day10.in" utf8 file-lines
[ process-line-lights ] map sum
