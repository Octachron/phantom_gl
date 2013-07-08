open FunOp
type t= {x:float;y:float}


let create x y = {x;y}


module Axioms=
struct
type vect=t 
let print v=Printf.printf "(%f,%f)" v.x v.y


let zero={x=0.;y=0.}

let (+) v w={x=v.x+.w.x;y=v.y+.w.y}
let (-) v w={x=v.x-.w.x;y=v.y-.w.y}
let ( * ) s v={x=s*.v.x;y=s*.v.y}
let ( / ) v s={x=v.x/.s;y=v.y/.s}

let ( *: ) v w= v.x*.w.x +. v.y*.w.y


end
include(Vector.Space(Axioms))

let vsplit  f v = f v.x v.y
let uniform =  vsplit <> Rgl.uniform2f
