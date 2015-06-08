open FunOp;;
open Bigarray;;
open Tsdl;;	
Random.init 121;;

let critical msg = function
| `Error e ->  Sdl.log "%s: %s" msg e; exit 1
| `Ok x -> x

let () = critical "Init video system" @@ Sdl.(init Init.video)

let w = critical "Window creation error" @@ 
  Sdl.create_window ~w:640 ~h:480 "Heat diffusion" Sdl.Window.opengl

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

let arrayf=Array1.create float32 c_layout

let foi =float_of_int

let gridIter m n f = for i=0 to (m-1) do (for j=0 to (n-1) do (f i j) done ) done 

let grid size=
	let norm i = (2.*. foi i/. foi (size-1)) -. 1. in
	let a = arrayf (2*size*size) in
	let f i j= let pos =2*(j+i*size) in  a.{pos}<- norm i; a.{pos+1}<- norm j in
		gridIter size size f;
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
	  gridIter (size-1) (size-1) indice;
	  a

let gridHeat size=
	let a=arrayf (size*size) in
	let heat i j= let pos=i*size+j in a.{pos}<- Random.float 1. in
	gridIter size size heat; a 


let size=512
let vertex = grid size
let index=gridTess size
let heat=gridHeat size 


let srv=Utils.load "shaders/laplace.vert"
let srf=Utils.load "shaders/laplace.frag"

let vert= Shader.compileVertFrom srv
let frag= Shader.compileFragFrom srf

let prog=Program.create vert frag;;
Program.use prog;;

let bGrid=BufferGl.createArray vertex
let bHeat=BufferGl.createArray heat

let bIndex=BufferGl.createElements GlEnum.triangles index



let [lGrid;lHeat]= List.map (VertexArray.getLoc ~prog) ["pos"; "heat"]

let (vGrid, vHeat) = Overarray.(full 2, full 1);;

VertexArray.withBuffer ~loc:lGrid bGrid vGrid;
VertexArray.withBuffer ~loc:lHeat bHeat vHeat;;

let rot=Uniform.from (module Vec3.GlMat) prog "Rot"
let proj=Uniform.( from (module Vec4.GlMat) prog "Proj" <*  sendTo  (Vec4.perspective 1. 10.) )



let diffusion dt =
	let clip i = if i<0 then i+size else ( if i>=size then i-size else i) in 
	let pos i j= (clip i) *size + (clip j) in
	let h i j= heat.{pos i j} in
	let laplace i j=  4.*.(h i j)-.  h (i+1) j   -. h (i-1) j -.  h i (j+1) -. h i (j-1) in
	let evolve a= for i=0 to size-1 do (
			 for j=0 to (size-1) do (
				let posC=pos i j in
				 a.{posC} <- heat.{posC}  -. dt*. (laplace i j)
			 ) done 
		) done 
	and copy a i j = let posC = pos i j in heat.{posC}<- a.{posC} in
	let aux a=
	 	evolve a; gridIter size size (copy a) in
	BufferGl.update bHeat aux
		
let dt=0.01


let draw t = 
  Draw.clear GlEnum.(color++depth); 
  diffusion dt ;  
  Uniform.(rot <<< Vec3.rmatrix Vec3.ex (-.t) ) ;
  Draw.elementsWith ~buf:bIndex ~start:0 ~len:(BufferGl.size bIndex) ; 
  Sdl.gl_swap_window w

let rec loop t=
 draw t;  
 let open Sdl in 
  let event = Event.create () in
	if poll_event (Some event) then
  match Event.( get event typ |> enum )with
	    | `Key_down  when Event.(get event keyboard_keycode) = K.escape -> Sdl.quit ()
	    | `Quit -> Sdl.quit ()
	    | _ ->  loop (t+.0.05)
  else loop (t +. 0.05 )


let () = 
  loop 0.


