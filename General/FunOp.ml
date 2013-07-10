
exception Impossible;;

let (-<- ) f g x=f(g(x))

external (|>) : 'a -> ('a -> 'b) -> 'b = "%revapply";;
external ( <| ) : ('a -> 'b) -> 'a -> 'b = "%apply"

