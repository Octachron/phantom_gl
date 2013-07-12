open FunOp;;
open Bigarray;;
	
Sdl.init [`VIDEO];;
let surface= Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF];;

Rgl.glewInit();;
Draw.enable GlEnum.depth_test;;

let vertex = 
 let open Vec3 in
  Overlay.fromList  (module Gl)  ([zero; ex; ey ; ez ])
	

let colors=
let open Vec3 in
	Overlay.fromList (module Gl) [ ex; ey; ez; const 1.  ]


let colors2=
	let open Vec3 in
	let l= List.map (fun v -> v/:8. +: const 0.5 ) [ex;ey;ez; const 1. ] in
	Overlay.fromList (module Gl) l

let index=Array1.of_array int16_unsigned c_layout
	  [| 0 ; 1 ; 2; 0 ; 1 ; 3; 0; 2 ;3; 1 ;2 ;3    |] 

let ntri = ( Array1.dim index) 

let srv=Utils.load "shaders/triangle.vert"
let srf=Utils.load "shaders/triangle.frag"

let vert= Shader.compileVertFrom srv
let frag= Shader.compileFragFrom srf

let prog=Program.create vert frag;;
Program.use prog;;

let bufferPos=BufferGl.create GlEnum.array vertex.Overlay.data GlEnum.stream_draw 



let bCol=BufferGl.create GlEnum.array colors.Overlay.data GlEnum.stream_draw <* BufferGl.writeTo 0 12  colors2.Overlay.data

let bIndex=BufferGl.create GlEnum.element index GlEnum.stream_draw



let posLoc=VertexArray.getLoc ~prog "pos";;
let colLoc=VertexArray.getLoc ~prog "color";;

let vPos= vertex.Overlay.slice
let vCol= vertex.Overlay.slice;;

VertexArray.withBuffer ~loc:posLoc bufferPos vPos;;
VertexArray.withBuffer ~loc:colLoc bCol vCol;;


let ax = Vec3.( normalised (ex +: ez ) ) 
let rot= Uniform.( from (module Vec3.GlMat) prog "rot" <* sendTo Vec3.id )

let proj=Uniform.( from (module Vec4.GlMat) prog "proj" <*  sendTo  (Vec4.perspective 1. 10.) )




let draw ()  = Draw.clear GlEnum.(color++depth);  Draw.elementsWith ~buf:bIndex ~primitives:GlEnum.triangles ~start:0 ~len:12 ; Sdlgl.swap_buffers()

let rec loop t =
	 Uniform.(rot <<<  Vec3.rmatrix ax t   );
	draw();
	match Sdlevent.poll() with
	    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
	    | Some Sdlevent.QUIT -> ()
	    | _ ->  loop (t+.0.05) ;;

Uniform.( rot <<< Vec3.id ; proj <<< Vec4.perspective 1. 10.);
loop 0. ;
Sdl.quit();;


