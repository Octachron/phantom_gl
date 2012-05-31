type t= (Hyperplane.t*Polygone.t) list

let tetrahedron s= 
let open Vector in 
let open Hyperplane in
 let z={x=0.;y=0.;z=0.} in
 let vx= { z with x=s }
 and vy= {z with y=s}  
 and vz= {z with z=s} 
 and vt={x=s;y=s;z=s} in
 [
	{normal= -1.*vx; pos=0.}, [z;vy;vz];
	{normal= -1.*vy; pos=0.}, [z;vz;vx];
	{normal= -1.*vz; pos=0.}, [z;vx;vy];
	{normal= -1.*vt; pos=s}, [vx;vy;vz]
]

let map f= List.map (fun (h,p) -> (h,Polygone.map f p) ) 

let intersection h ph=
let f (lf,le) (g,p) = 
 let (i,p') = Polygone.intersection h p in 
 match i with
  | Polygone.Seg s -> ((g,p')::lf, s::le)
  | Polygone.All -> ((g,p)::lf, le)
  | Polygone.Nil -> (lf, le) in
let lf, le = List.fold_left f ([],[]) ph in
let pn = Polygone.reconnect le in
(h,pn)::lf
 

