open FunOp
type t= {x:float;y:float;z:float;t:float}


let create x y z t= {x;y;z; t }


module Axioms=
struct
type vect=t 
let print v=Printf.printf "(%f,%f,%f,%f)" v.x v.y v.z v.t


let zero={x=0.;y=0.;z=0.;t=0.}

let (+) v w={x=v.x+.w.x;y=v.y+.w.y;z=v.z+.w.z; t = v.t  +. w.t }
let (-) v w={x=v.x-.w.x;y=v.y-.w.y;z=v.z-.w.z; t = v.t  -. w.t}
let ( * ) s v={x=s*.v.x;y=s*.v.y;z=s*.v.z; t=s*.v.t }
let ( / ) v s={x=v.x/.s;y=v.y/.s;z=v.z/.s; t=v.t/. s}

let ( *: ) v w= v.x*.w.x +. v.y*.w.y+.v.z*.w.z +. v.t*.w.t

end
include(Vector.Space(Axioms))



(** Opengl interface function **)

let converter =let open Overlay in
 { read = ( fun reader -> {x=reader 0;y=reader 1; z=reader 2; t =reader 3} );  
  write = ( fun writer v ->  (writer 0 v.x; writer 1 v.y; writer 2 v.z; writer 3 v.t)) }



type ctype=Bigarray.float32_elt
type otype=float
let atype=Bigarray.float32
let adim=4
 
let vsplit  f v = f v.x v.y v.z v.t
let uniform =  vsplit -<- Rgl.uniform4f
