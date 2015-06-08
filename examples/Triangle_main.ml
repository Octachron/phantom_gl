 open FunOp;;
open Bigarray;;
open Tsdl

let critical msg = function
| `Error e ->  Sdl.log "%s: %s" msg e; exit 1
| `Ok x -> x

let () = critical "Init video system" @@ Sdl.(init Init.video)

let w = critical "Window creation error" @@ 
  Sdl.create_window ~w:640 ~h:480 "SDL OpenGL" Sdl.Window.opengl

let () = 
  let open Sdl in
  critical "Gl major version" @@ gl_set_attribute Gl.context_major_version 3; 
  critical "Gl minor version" @@ gl_set_attribute Gl.context_minor_version 2;
  critical "Gl profile" @@ gl_set_attribute Gl.context_profile_mask Gl.context_profile_core

let ctx = critical "Context creation error" @@ Sdl.gl_create_context w
let () = critical "Failed to make context current"  @@ Sdl.gl_make_current w ctx

let () = 
	  critical "Double buffering" @@ Sdl.gl_set_attribute Sdl.Gl.doublebuffer 1
	  ; critical "Depth size" @@ Sdl.gl_set_attribute Sdl.Gl.depth_size  32

let () = Rgl.glewInit()
let () = Draw.enable GlEnum.depth_test;;
let vao = VAO.( create () <* bind )

let vertex = 
 let open Vec3 in
  Overarray.fromList  (module Gl)  [zero; ex; ey ; ez ]
	

let colors=
let open Vec3 in
	Overarray.fromList (module Gl) [ ey; ey; ey; ey  ]


let colors2=
	let open Vec3 in
	let l=  [ex;ey;ez; const 1. ] in
	Overarray.fromList (module Gl) l

let index=Array1.of_array int16_unsigned c_layout
	  [| 0 ; 1 ; 2; 0 ; 1 ; 3; 0; 2 ;3; 1 ;2 ;3   |] 

let ntri = ( Array1.dim index) 

let vert= Shader.compileVertFrom -<- Utils.load <| "examples/shaders/triangle.vert"
let frag= Shader.compileFragFrom -<- Utils.load <| "examples/shaders/triangle.frag"


let prog=Program.create vert frag <* Program.use;;


let bufferPos=BufferGl.createArray vertex.Overarray.data



let bCol=BufferGl.createArray colors.Overarray.data <* BufferGl.writeTo 3 9  colors2.Overarray.data

let bIndex=BufferGl.createElements GlEnum.triangles index



let [posLoc; colLoc] = List.map (VertexArray.getLoc ~prog) ["pos"; "color"];;

let vPos= vertex.Overarray.layout
let vCol= vertex.Overarray.layout;;

VertexArray.withBuffer ~loc:posLoc bufferPos vPos;;
VertexArray.withBuffer ~loc:colLoc bCol vCol;;


let ax = Vec3.( normalised (ex +: ez ) ) 
let rot= Uniform.( from (module Vec3.GlMat) prog "rot" <* sendTo Vec3.id )

let proj=Uniform.( from (module Vec4.GlMat) prog "proj" <*  sendTo  (Vec4.perspective 1. 10.) )



let draw bIndex  =
  Draw.clear GlEnum.(color++depth);
  Draw.elementsWith ~buf:bIndex ~start:0 ~len:12 ;
  Sdl.gl_swap_window w

let rec loop t =
  Uniform.(rot <<<  Vec3.rmatrix ax t   );
	draw bIndex;
  let open Sdl in 
  let event = Event.create () in
	if poll_event (Some event) then
  match Event.( get event typ |> enum )with
	    | `Key_down  when Event.(get event keyboard_keycode) = K.escape -> Sdl.quit ()
	    | `Quit -> Sdl.quit ()
	    | _ ->  loop (t+.0.05)
  else loop (t +. 0.05 )

let () = 
  let () = let open Uniform in 
    rot <<< Vec3.id ;
    proj <<< Vec4.perspective 1. 10. in
  loop 0. 

