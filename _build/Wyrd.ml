open FunOp

let ()=
	let v=Vector.create 1. 0. 0. 
	and w=Vector.create 1. 0. 1.
	and h=Hyperplane.create (Vector.create 1. 0. 0.)  0.
	in
	print_float VectOp.(h||(2.*v-3.*w))



	

let glVert v= let open Vector in GlDraw.vertex3 (v.x,v.y,v.z)

let display p =
  let ts= Polygone.triangles p in
  let cts = List.fold_left ( @ ) [] ts in
    List.iter glVert cts
 

let colorize n= 
let nf = float_of_int n in
let f s =(1. +.  cos( nf/.s) )/.2. in
let c = f 2. , f 5., f 12. in
GlDraw.color c

let displayH h= 
	 GlClear.clear [`color;`depth];
         GlDraw.begins `triangles;
	 ignore ( List.fold_left (fun n (h,p) -> colorize n ; display p; n+1) 2 h); 
	 GlDraw.ends (); 
         Sdlgl.swap_buffers()
	



let () =
 let hv v= Hyperplane.create v 0.25 in
 let z=Vector.zero in
 let vl= Vector.( [{z with x= -1.} ; {z with y= -1.}; {z with z= -1.}  ] ) in
 let th= Polyhedron.tetrahedron 1. in
 let th'= List.fold_left (fun ph v -> Polyhedron.intersection (hv v) ph) th vl in
 let rotation  = Vector.(rotation (normalized (create 1. 1. 0.)) )
 and trans t = Vector.((+) (t* (create 1. 0. 0.)))
 in 	
 let rec loop t =
    match Sdlevent.poll() with
    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
    | Some Sdlevent.QUIT -> ()
    | _ -> displayH (Polyhedron.map (rotation t) th'); loop (t+.0.01)
  in
  Sdl.init [`VIDEO];
  ignore (Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF]);
  Gl.enable `depth_test;
  loop 0.;
  Sdl.quit()


	