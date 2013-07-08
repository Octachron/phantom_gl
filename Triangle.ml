open FunOp;;
open Bigarray;;
	
Sdl.init [`VIDEO];;
let surface= Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF];;

Rgl.glewInit();;

let vertex = 
 let open Vec3 in
 let z=zero in 
  Overlay.fromList  (module Vec3)  [z; {z with x=1.}; {z with y=1.} ; {z with z=1.} ] 
	

let colors=
let open Vec4 in
let b={zero with t=1.} in
	Overlay.fromList (module Vec4) [{b with x=1.}; {b with y=1.}; {b with z=1.}; {b with y=1.;z=1.} ]


let index=Array1.of_array int16_unsigned c_layout
	  [| 0 ; 1 ; 2; 0 ; 1 ; 3; 0; 2 ;3; 1 ;2 ;3    |] 

let srv=Utils.load "shaders/triangle.vert"
let srf=Utils.load "shaders/triangle.frag"

let vert= Shader.compileVertFrom srv
let frag= Shader.compileFragFrom srf

let prog=Program.create vert frag;;
Program.use prog;;

let bufferPos=BufferGl.create GlEnum.array vertex.Overlay.data GlEnum.stream_draw
let bCol=BufferGl.create GlEnum.array colors.Overlay.data GlEnum.stream_draw

let bIndex=BufferGl.create GlEnum.element index GlEnum.stream_draw



let posLoc=VertexArray.getLoc ~prog "pos";;
let colLoc=VertexArray.getLoc ~prog "color";;

let vPos= Overlay.(full 3)
let vCol= Overlay.(full 4);;

VertexArray.withBuffer ~loc:posLoc bufferPos vPos;;
VertexArray.withBuffer ~loc:colLoc bCol vCol;;

let alpha= Uniform.scalar prog "alpha" 0.25
let alpha=Uniform.(alpha =$ 0.5 )

let draw ()  = Draw.clear GlEnum.(color++depth);  Draw.elementsWith ~buf:bIndex ~primitives:GlEnum.triangles ~start:0 ~len:3 ; Sdlgl.swap_buffers()

let rec loop t alpha =
	let alpha'= Uniform.(alpha =$ ( (1. +. cos t)/.2. ) ) in
	draw();
	match Sdlevent.poll() with
	    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
	    | Some Sdlevent.QUIT -> ()
	    | _ ->  loop (t+.0.05) alpha' ;;

loop 0. alpha;
Sdl.quit();;


