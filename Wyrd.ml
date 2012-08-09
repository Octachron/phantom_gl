open FunOp


	

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
	         
	
let modern ()=
let rec loop ()= match Sdlevent.poll() with
| Some Sdlevent.KEYDOWN {Sdlevent.keysym=Sdlkey.KEY_ESCAPE} | Some Sdlevent.QUIT -> ()
| _ -> loop ()
in
 Sdl.init [`VIDEO];
ignore (Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF]);
GlM.glewInit ();
Gl.enable `depth_test;
  loop ();
  Sdl.quit()




let  () =
 let hv v= Hyperplane.create v 0.25 in
 let z=Vector.zero in
 let vl= Vector.( [{z with x= -1.} ; {z with y= -1.}; {z with z= -1.}  ] ) in
 let th= Polyhedron.tetrahedron 1. in
 let th'= List.fold_left (fun ph v -> Polyhedron.intersection (hv v) ph) th vl in
 let rotation  = Vector.(create 1. 1. 0. |> normalized |> rotation )
 and trans t = Vector.((+) (t* (create 1. 0. 0.)))
 in 	
   
 let rec loop state t =
 let vect t= Vector.({x=cos (1.117*.t); y=sin t; z=4.+.cos (2.14*.t)}) in
 let state= Uniform.( state =$ (cos (7.111*.t), vect t)  ) in
    match Sdlevent.poll() with
    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
    | Some Sdlevent.QUIT -> ()
    | _ ->  displayH (Polyhedron.map (rotation t) th'); loop state (t+.0.01)
  in
  Sdl.init [`VIDEO];
  let surface= Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF] in
  GlM.glewInit();
  let srcV=Utils.load "shaders/test.vert" and srcF = Utils.load "shaders/test.frag" in 
  let vert= Shader.compileVertFrom srcV and  frag = Shader.compileFragFrom srcF in 
  let print x= Printf.printf "Shader id %d \n" (Shader.uid x) 
  in
   print vert; print frag;
  let prog=Program.rise vert frag in
  let mist=Uniform.scalar prog "mist" 0. 
  and pos=Uniform.vector prog "pos" Vector.zero
in
  Gl.enable `depth_test;
  loop (Uniform.join mist pos) 0.;
  Sdl.quit()


	
