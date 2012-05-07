
type t={x:float;y:float;z:float}
let print v=Printf.printf "(%f,%f,%f)" v.x v.y v.z
let create x y z = {x;y;z} 

let (+) v w={x=v.x+.w.x;y=v.y+.w.y;z=v.z+.w.z}
let (-) v w={x=v.x-.w.x;y=v.y-.w.y;z=v.z-.w.z}
let ( * ) s v={x=s*.v.x;y=s*.v.y;z=s*.v.z}

let ( *: ) v w= v.x*.w.x +. v.y*.w.y+.v.z*.w.z

