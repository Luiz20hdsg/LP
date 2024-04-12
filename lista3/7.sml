fun max(x,y) = if x > y then x else y

fun good_max(nil) = 0
  | good_max(x::nil) = x
  | good_max(x::xs) = let val y = good_max(xs) in max(x,y) end;