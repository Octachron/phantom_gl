
exception Impossible;;

let (<>) f g x=f(g(x))
let (<|) f x = f x
let (|>) x g = g x
