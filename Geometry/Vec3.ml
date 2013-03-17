open FunOp
type t= {x:float;y:float;z:float}
let create x y z = {x;y;z} 
module Axioms=
struct
type vect=t 
let print v=Printf.printf "(%f,%f,%f)" v.x v.y v.z


let zero={x=0.;y=0.;z=0.}

let (+) v w={x=v.x+.w.x;y=v.y+.w.y;z=v.z+.w.z}
let (-) v w={x=v.x-.w.x;y=v.y-.w.y;z=v.z-.w.z}
let ( * ) s v={x=s*.v.x;y=s*.v.y;z=s*.v.z}
let ( / ) v s={x=v.x/.s;y=v.y/.s;z=v.z/.s}

let ( *: ) v w= v.x*.w.x +. v.y*.w.y+.v.z*.w.z
end
include(Vector.Space(Axioms))

let ( *^ ) v w  = {x=v.y*.w.z-.v.z*.w.y; y =v.z*.w.x -. v.x *. w.z; z= v.x*.w.y -. v.y *. w.x}

let rotation ax t v= 
	let p = projection ax v in
	(cos(t) * (v-p) + p+  sin(t) * (ax *^ v)) 

