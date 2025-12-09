&fras "day3.in"
P ← (
  # get position of largest digit in
  # array, not including final digit
  ⊸(⊢⍖↘₋₁)
  # select as digit, get position of
  # second largest digit in rest of array
  ⊃⊏(⊏⊸(⊢⍖)↘+1)
  # convert to number
  ⋕⊂
)
/+ ⊜P ⊸≠@\n
