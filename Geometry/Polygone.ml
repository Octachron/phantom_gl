type t=Vector.t list

let cube s= 
let open Vector in 
let z= create 0. 0. 0. in
[z; {z with x=s}; {z with y=s; x=s}; {z with y=s} ]

let create l=l

let print l= 
 let rec mid= function
  | [] -> Printf.printf "]"
  | [a] -> Vector.print a; mid []
  | a::b::q-> Vector.print a; Printf.printf"->"; mid (b::q) 
 in
Printf.printf "["; mid l

let triangles: t -> t list=
let rec separation  t ls  = function
| a::b::c::q -> separation ([a;b;c]::t) (c::a::ls)  q
| [a;b] -> test t (b::a::ls)
| [a] -> test t (a::ls)
| [] -> test t ls
and test t=function
| a::b::c::q as l-> separation t [] l
| l -> t in
separation [] [] 

let map=List.map

let segint h a b= 
	let p,n= VectOp.(h||a, h||b) in
	let t= n/.(n-.p) in
	VectOp.(t*a  + (1.-.t) * b) 

let revcat l1 l2= List.fold_left ( fun l x-> x::l) l2 l1 




