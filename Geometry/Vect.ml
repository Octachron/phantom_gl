open FunOp

module type Dim=
sig
	val dim : n
end



module Vect = functor ( D : Dim ) ->
struct
type t= float Array.t

type matrix =float Array.t


let fromArray v= 
let a= Array.make D.dim 0. in
for i=0 to (min (Array.length v) D.Dim )-1 do
	a.(i)<-v.(i)
done; a 

let gen=Array.init D.dim


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
