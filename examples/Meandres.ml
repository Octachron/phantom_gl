open Utils.FunOp
open Bigarray
open Tsdl
open Range
open Result

;; Random.init 121

let critical msg = function
| Error (`Msg e) ->  Sdl.log "%s: %s" msg e; exit 1
| Ok x -> x

let () = critical "Init video system" @@ Sdl.(init Init.video)

let w = critical "Window creation error" @@ 
  Sdl.create_window ~w:1600 ~h:850 "Random meandres" Sdl.Window.opengl
  
let () = 
  critical "Fullscreen failure" @@ 
  Sdl.set_window_fullscreen w Sdl.Window.fullscreen_desktop

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
let vao = VAO.( create () <* bind )

let arrayf=Array1.create float32 c_layout

let foi =float_of_int

let square size =
  (range size) ^ (range size) 

let grid size=
  let norm i = (2.*. foi i/. foi (size-1)) -. 1. in
  let a = arrayf (2*size*size) in
  let f i j= let pos =2*(j+i*size) in  a.{pos}<- norm i; a.{pos+1}<- norm j in
  iter f @@ square size;
  a

let gridTess size=
  let nvertex = 6 in
  let a=Array1.create int32 c_layout (nvertex*(size-1)*(size-1)) in
  let (<= ) pos (i,j) = a.{pos} <- Int32.of_int (i*size+j) in
  let vert pos l = List.iteri (fun i x -> (pos + i) <= x ) l in  
  let indice i j=
    vert ( nvertex*( j+i*(size-1) ) )
      [ i,j ; i+1,j ; i,j+1; i+1,j+1 ; i,j+1; i+1,j ]  
  in
  iter indice @@ square ( size - 1 );
  a



let size=512
let vertex = grid size
let index=gridTess size

let map2 f (x,y) = f x, f y

let srv, srf = map2 Utils.load (
    "examples/shaders/meandres.vert", "examples/shaders/meandres.frag"
  )
    
let vert= Shader.compileVertFrom srv
let frag= Shader.compileFragFrom srf

let prog=Program.create vert frag;;
Program.use prog;;

let bGrid = BufferGl.createArray vertex

let bIndex=BufferGl.createElements GlEnum.triangles index

let lGrid = VertexArray.getLoc ~prog "pos"

let vGrid= Overarray.full 2

;; VertexArray.withBuffer ~loc:lGrid bGrid vGrid

;; Random.self_init ()

let size = 3 * 4 * 4 
let r = range size
let xs, vs = 
  let a, b = arrayf size, arrayf size in
  iter_on r (fun i -> a.{i} <- Random.float 6.; b.{i} <- Random.float 0.2 -. 0.1 );
  a, b

let random_walk xs = 
  iter_on r (fun i -> vs.{i} <- 0.99 *. vs.{i} +. Random.float 0.02 -. 0.01 ; xs.{i}<- 0.999 *. xs.{i} +. vs.{i} ) 
  ; xs

let u_xs = Uniform.scalar_array prog "xs"

let draw xs = 
  Draw.clear GlEnum.(color); 
  Uniform.(u_xs <% xs ) ;
  Draw.elementsWith ~buf:bIndex ~start:0 ~len:(BufferGl.size bIndex) ; 
  Sdl.gl_swap_window w

let rec loop xs=
  draw xs;  
  let open Sdl in 
  let event = Event.create () in
  if poll_event (Some event) then
    match Event.( get event typ |> enum )with
    | `Key_down  when Event.(get event keyboard_keycode) = K.escape -> Sdl.quit ()
    | `Quit -> Sdl.quit ()
    | _ ->  loop @@ random_walk xs
  else loop @@ random_walk xs
      

let () = 
  loop xs


