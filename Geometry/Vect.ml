open FunOp

module type Dim=
sig
	val dim : int
end



module Vect = functor ( D : Dim ) ->
struct
type t= float array

type matrix =float array

let dim=D.dim

let fromArray v= 
let a= Array.make D.dim 0. in
for i=0 to (min (Array.length v) dim )-1 do
	a.(i)<-v.(i)
done; a 

let gen=Array.init D.dim

let zero=Array.make dim 0.

let mapOp op a b=gen (fun i ->  op a.(i) b.(i) )

let reduce op e a b=
let acc =ref e in
for i=0 to D.dim -1 do acc <- op !e a.(i) b.(i) done;
!acc 

let ( +! ) =mapOp (+.)
let ( -! ) =mapOp (-.)
let ( *! ) s= map ( s *. )
let ( /! ) v s= map ( /.  x ) v
let (!*!) =reduce  (fun acc x x' -> acc+. x*.x') 0.

let norm2 v = v !*! v
let norm = sqrt <> norm2
let normalised v = v/! (norm v)

let proj p v = (v!*!p ) *! p 

end
