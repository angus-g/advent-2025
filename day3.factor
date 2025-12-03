USING: arrays assocs hashtables io.encodings.utf8 io.files
kernel math math.order ranges sequences sequences.extras
sorting.extras ;
IN: day3

: find-max ( seq -- n )
  dup
  ! sort from left to right
  [ [ >=< ] argsort ]
  ! sort from right to left
  [ [ reverse [ >=< ] argsort ] keep length 1 - [ swap - ] curry map ] bi
  [ swap [ <= ] curry drop-while ?first ] curry map-find
  [ [ swap nth 48 - ] curry ] [ [ swap nth 48 - 10 * ] curry ] bi*
  bi + ;

! part 2 is like knapsack
! m[i, j] is max obtained with index up to i, with j digits
! m[-1, j] = 0 ! without any digits, there is no answer
! m[i, 0] = 0 ! if we never pick anything, there is no answer
! m[i, 12] = m[i-1, 12]
! m[i, j] = max(m[i-1,j], m[i-1,j-1]*10 + d_i)

:: dp ( seq -- best )
  seq length :> len
  len 12 * <hashtable> :> dp

  ! set base cases
  12 [0..b] [ -1 swap 2array [ 0 ] dip dp set-at ] each
  len <iota> [ 0 2array [ 0 ] dip dp set-at ] each

  ! recurse, with selected digits as outer loop
  12 [1..b] [| j |
    len <iota> [| i |
      i 1 - j 2array dp at
      i 1 - j 1 - 2array dp at 10 *
      i seq nth 48 - +
      max
      i j 2array dp set-at
    ] each
  ] each
  len 1 - 12 2array dp at ;

"day3.in" utf8 file-lines

[ [ find-max ] map sum ]
[ [ dp ] map sum ] bi