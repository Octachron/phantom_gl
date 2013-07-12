
exception Impossible;;

let (-<- ) f g x=f(g(x))

external (|>) : 'a -> ('a -> 'b) -> 'b = "%revapply";;
external ( <| ) : ('a -> 'b) -> 'a -> 'b = "%apply"

let ( <* ) : 'a -> ('a -> unit )->'a = fun x f -> let _ = f x in x 

