open FunOp

	

let glVert v= let open Vec3 in GlDraw.vertex3 (v.x,v.y,v.z)

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
	         
	

let cube =let hv v= Vec3.hyperplane v 0.25 in
 let z=Vec3.zero in
 let vl= Vec3.( [{z with x= -1.} ; {z with y= -1.}; {z with z= -1.}  ] )
 and th= Polyhedron.tetrahedron 1. in
  List.fold_left (fun ph v -> Polyhedron.intersection (hv v) ph) th vl


let rotation  = Vec3.(create 1. 1. 0. |> normalized |> rotation )
let trans t = Vec3.((+) (t* (create 1. 0. 0.)))
let vect t= Vec3.({x=cos (1.117*.t); y=sin t; z=4.+.cos (2.14*.t)}) 

let upos t uni = Uniform.( uni =$ (cos (7.111*.t), vect t)  )
  	

let rec loop state t =
 let state=upos t state  in
    match Sdlevent.poll() with
    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
    | Some Sdlevent.QUIT -> ()
    | _ ->  displayH (Polyhedron.map (rotation t) cube); loop state (t+.0.1) ;;


  Sdl.init [`VIDEO];;
  let surface= Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF] ;;
  Rgl.glewInit();;
  Gl.enable `depth_test;;

  let t=Texture.create (256,256) 
  and t2=Texture.create (256,256) in
Printf.printf "Texture id : %u \n" Texture.(t2.uid);;

  let srcV=Utils.load "shaders/test.vert" and srcF = Utils.load "shaders/test.frag" 
 
  let vert= Shader.compileVertFrom srcV and  frag = Shader.compileFragFrom srcF 
  let print x= Printf.printf "Shader id %d \n" (Shader.uid x);;

   print vert; print frag;;

  let prog=Program.create vert frag
  let mist=Uniform.scalar prog "mist" 0.  
  let pos=Uniform.vector prog "pos" Vec3.zero;;

  loop (Uniform.join mist pos) 0.;
  Sdl.quit()


	
