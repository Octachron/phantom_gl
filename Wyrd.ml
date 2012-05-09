

let ()=
	let v=Vector.create 1. 0. 0. 
	and w=Vector.create 1. 0. 1.
	and h=Hyperplane.create (Vector.create 1. 0. 0.)  0.
	in
	print_float VectOp.(h||(2.*v-3.*w))


let display() =
  GlClear.clear [`color];
  GlDraw.begins `triangles;
  GlDraw.color (0.0, 1.0, 0.0);
  GlDraw.vertex2 (-0.5, -0.5);
  GlDraw.vertex2 ( 0.0,  0.5);
  GlDraw.vertex2  (0.5, -0.5);
  GlDraw.ends();
  Sdlgl.swap_buffers()




let () =
  Sdl.init [`VIDEO];
  let _ = Sdlvideo.set_video_mode ~w:640 ~h:480 ~bpp:0 [`OPENGL; `DOUBLEBUF] 
in
  let rec loop() =
    match Sdlevent.poll() with
    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
    | Some Sdlevent.QUIT -> ()
    | _ -> display(); loop()
  in
  loop();
  Sdl.quit()


	
