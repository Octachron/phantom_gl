type 'a t = Nil | Chain of 'a*'a t*'a t

exception ErrNil

let ( => ) x  =function 
| Nil -> let rec c=Chain(x,c,c) in c
| Chain (y,p,n) -> let rec c=Chain( x,p, Chain(y,c,n)) in c

let content = function
| Chain(a,_,_) -> a
|Nil -> raise ErrNil


let next = function
|Nil -> Nil
| Chain (a,cyp,cyn) -> cyn


let  iter f= function
| Nil -> ()
| guard -> 
   let rec riter c = if c=guard then () else  f (content c); riter (next c) in
	f (content guard); riter (next guard)

