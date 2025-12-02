USING: grouping io.encodings.utf8 io.files kernel math
math.order math.parser sequences ;
IN: day1

: parse-rotate ( s -- n ) unclip [ string>number ] [ 82 = 1 -1 ? ] bi* * ;

: next-mult ( n -- n ) [ 100 rem 100 swap - ] keep + ;
: next-mult-inc ( n -- n ) dup 100 mod zero? [ next-mult ] unless ;
: prev-mult ( n -- n ) neg next-mult neg ;
: prev-mult-inc ( n -- n ) neg next-mult-inc neg ;

: crossings ( x y -- n ) 2dup > [ [ prev-mult ] [ next-mult-inc ] bi* ] [ [ next-mult ] [ prev-mult-inc ] bi* swap ] if - 100 /i -1 max 1 + ;

"day1.in" utf8 file-lines

[ 50 [ parse-rotate + 100 mod ] accumulate
  [ zero? ] count nip ]
[ 50 [ parse-rotate + ] accumulate
  2 clump [ first2 crossings ] map sum nip ]
bi