type t= (Vec3.hyperplane*Polygone.t) list

let tetrahedron s= 
let open Vec3 in 
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

let cube = 
	let open Vec3.in
	let z=zero in
	let vx= { z with x=1. }
 	and vy= {z with y=1. }  
 	and vz= {z with z=1. } in
[
	{normal = -1.*vz; pos=0}, [z, vx ,vx+vy , vy ];
	{normal = -1.*vy; pos=0}, [z, vx ,vx+vz , vz ];
	{normal = -1.*vx; pos=0}, [z, vy ,vy+vz , vz ];
	{normal =  vx; pos=1}, [vx, vx+vz ,vx+vz+vy , vx+vy ];
	{normal =  vz; pos=1}, [vy, vy+vz ,vy+vz+vx , vy+vx ];
	{normal =  vy; pos=1}, [vz, vz+vx ,vz+vx+vy , vz+vy ];
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
 

