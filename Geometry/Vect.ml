open FunOp


exception IncorrectDimension of (int*int)
let assertDim dimA dimB = if ( dimA <> dimB) then raise ( IncorrectDimension (dimA,dimB) )

module type Dim=
sig
	val dim : int
end



module Make = functor ( D : Dim ) ->
struct
type 'a t= float array

let vector (x: 'a t) = (x : [`Vect] t)
let matrix (x: 'a t) = (x : [`Matrix] t)

let dim=D.dim

let fromArray : 'a. float array -> 'a t = function v -> 
assertDim (Array.length v) dim;
let a= Array.make D.dim 0. in
for i=0 to dim-1 do
	a.(i)<-v.(i)
done; a 

let gen :  'a. (int->float) -> 'a t=Array.init D.dim
let const : 'a. float -> 'a t = fun c ->  Array.make dim c


let zero : [`Vect] t =const 0.

let canon : int -> [`Vect ] t = fun k ->  gen (fun i -> if k=i then 1. else 0. ) 

let mapOp : (float->float->float) -> 'a t -> 'a t -> 'a t  = fun op a b -> gen (fun i ->  op a.(i) b.(i) )

let reduce op e a b=
let acc =ref e in
for i=0 to D.dim -1 do acc := ( op (!acc) a.(i) b.(i) ) done;
!acc 

let (  +: ) =mapOp (+.)
let (  -: ) =mapOp (-.)
let (  *: ) s= Array.map ( ( *. )  s )
let (  /: ) v s= Array.map (fun x -> x /.  s ) v
let ( <*> ) : 'a t -> 'a t -> float =reduce  (fun acc x x' -> acc+. x*.x') 0.



let norm2 : 'a t -> float   = fun v -> v <*>  v
let norm :  'a t -> float   = sqrt -<- norm2
let normalised : 'a t -> 'a t  = fun v ->  v/: (norm v)

let proj : 'a t -> 'a t -> 'a t = fun p v -> (v <*> p ) *: p 

end
