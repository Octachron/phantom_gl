type t={normal:Vector.t; pos:float}

let create v p={normal=v; pos=p}

let (||) h v= Vector.(h.normal*:v) +. h.pos

let print h=
let v=h.normal in
let (x,y,z)=Vector.( (v.x,v.y,v.z) ) in
Printf.printf "%f:%f:%f:%f" x y z h.pos 
