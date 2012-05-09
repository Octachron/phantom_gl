

let ()=
	let v=Vector.create 1. 0. 0. 
	and w=Vector.create 1. 0. 1.
	and h=Hyperplane.create (Vector.create 1. 0. 0.)  0.
	in
	print_float VectOp.(h||(2.*v-3.*w))


let ()=
	let cube=Polygone.cube 1. in
	let ts=Polygone.triangles cube in
	Polygone.print cube;print_newline ();
	List.iter (fun p-> Polygone.print p;print_newline() ) ts
	

let glVert v= let open Vector in GlDraw.vertex3 (v.x,v.y,v.z)

let display p =
  let ts= Polygone.triangles p in
  let cts = List.fold_left ( @ ) [] ts in
    GlClear.clear [`color];
    GlDraw.begins `triangles;
    GlDraw.color (0.0, 0.0, 1.0);
    List.iter glVert cts;
    GlDraw.ends (); 
    Sdlgl.swap_buffers()




let () =
  let p0= let open Vector in 
    Polygone.create [
     {x=0.;y=0.;z=0.}; 
     {x=0.;y=0.5;z=0.};
     {x=0.5;y=0.5;z=0.};
     {x=0.5;y=0.;z=0.} ]
 and h= Hyperplane.create (Vector.create (1.) 0. 0.) (-0.25) in
 let p= Polygone.intersection h p0 
 and rotation  = Vector.(rotation (create 0. 0. 1.)) 
 and trans t = Vector.((+) (t* (create 1. 0. 0.)))
 in 
  Sdl.init [`VIDEO];
  let _ = Sdlvideo.set_video_mode ~w:640 ~h:480 ~bpp:0 [`OPENGL; `DOUBLEBUF] 
in
  let rec loop t =
    match Sdlevent.poll() with
    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
    | Some Sdlevent.QUIT -> ()
    | _ -> display (Polygone.map (rotation 0.) p0); loop (t+.0.01)
  in
  loop 0.;
  Sdl.quit()


	
