open FunOp
type t= {x:float;y:float;z:float}

module Matrix=struct
type mat = {vx:t; vy : t; vz : t}

let create vx vy vz = {vx;vy;vz}

let zero =  let z = {x=0.;y=0.;z=0.} in create z z z
let id =  let z = {x=0.;y=0.;z=0.} in create {z with x=1.} { z with y=1. }  {z with z=1.}

end

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


let transpose m= 
let open Matrix in
 let line p = {x=p m.vx ; y =p m.vy ; z =p m.vz } in
 {vx= line (fun v -> v.x); vy= line (fun v -> v.y); vz= line (fun v -> v.z); }

let ( *. ) m v = Matrix.( {x=m.vx *: v; y = m.vy *: v; z= m.vz *: v } ) 

let ( *! ) m n =
 let open Matrix in
 let t=transpose n  in
 let line v = {x= v*:t.vx; y=v*:t.vy; z=v*:t.vz } in
	{vx=line m.vx; vy=line m.vy; vz=line m.vz}   



end
include(Vector.Space(Axioms))

let ( *^ ) v w  = {x=v.y*.w.z-.v.z*.w.y; y =v.z*.w.x -. v.x *. w.z; z= v.x*.w.y -. v.y *. w.x}

let rotation ax t v= 
	let p = projection ax v in
	(cos(t) * (v-p) + p+  sin(t) * (ax *^ v)) 


(** Opengl interface function **)
let converter =let open Overlay in
 { read = ( fun reader -> {x=reader 0;y=reader 1; z=reader 2} );  
  write = ( fun writer v ->  (writer 0 v.x; writer 1 v.y; writer 2 v.z)) }



type ctype=Bigarray.float32_elt
type otype=float
let atype=Bigarray.float32
let adim=3
  
let vsplit  f v = f v.x v.y v.z
let uniform =  vsplit <> Rgl.uniform3f


