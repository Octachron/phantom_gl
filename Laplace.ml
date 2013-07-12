open FunOp;;
open Bigarray;;
	
Sdl.init [`VIDEO];;
Random.init 121;;

let surface= Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF];;

Rgl.glewInit();;
Draw.enable GlEnum.depth_test;;


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
	let a=Array1.create int32 c_layout (4*(size-1)*(size-1)) in
	let (<= ) pos (i,j) = a.{pos} <- Int32.of_int (i*size+j) in
 	let indice i j= let pos =4*( j+i*(size-1) )  in
			 pos    <= (i,j) ;
			(pos+1) <= (i+1,j) ;
			(pos+2) <= (i+1,j+1) ;
			(pos+3) <= (i,j+1)  
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

let bGrid=BufferGl.create GlEnum.array vertex GlEnum.stream_draw
let bHeat=BufferGl.create GlEnum.array heat GlEnum.stream_draw

let bIndex=BufferGl.create GlEnum.element index GlEnum.stream_draw



let [lGrid;lHeat]= List.map (VertexArray.getLoc ~prog) ["pos"; "heat"]

let (vGrid, vHeat) = Overlay.(full 2, full 1);;

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



let rec loop t= 
Draw.clear GlEnum.(color++depth); 
diffusion dt ;  
 Uniform.(rot <<< Vec3.rmatrix Vec3.ex (-.t) ) ;
Draw.elementsWith ~buf:bIndex ~primitives:GlEnum.quads ~start:0 ~len:(BufferGl.size bIndex) ; 
Sdlgl.swap_buffers();
	match Sdlevent.poll() with
	    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
	    | Some Sdlevent.QUIT -> ()
	    | _ ->  loop  (t+.dt) ;;

loop 0.;
Sdl.quit();;


