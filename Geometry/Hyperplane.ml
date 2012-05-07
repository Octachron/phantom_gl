type t={normal:Vector.t; pos:float}

let create v p={normal=v; pos=p}

let (||) h v= Vector.(h.normal*:v) +. h.pos;

let print h=Printf.printf "%f:%f:%f:%f" h.Vector.normal.x h.Vector.normal.y h.Vector.normal.z h.pos 
