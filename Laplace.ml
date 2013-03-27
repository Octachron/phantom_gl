open FunOp;;

	
Sdl.init [`VIDEO];;
Random.init 121;;

let surface= Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF];;

Rgl.glewInit();;


let arrayf=Bigarray.Array2.create Bigarray.float32 Bigarray.c_layout



let foi =float_of_int

let gridIter m n f = for i=0 to (m-1) do (for j=0 to (n-1) do (f i j) done ) done 

let grid size=
	let norm i = (2.*. foi i/. foi (size-1)) -. 1. in
	let a = arrayf (size*size) 2 in
	let f i j= let pos =j+i*size in  a.{pos,0}<- norm i; a.{pos,1}<- norm j in
		gridIter size size f;
		a


let gridTess size=
	let a=Bigarray.Array2.create Bigarray.int32 Bigarray.c_layout (4*(size-1)*(size-1)) 1 in
	let (<= ) pos (i,j) = a.{pos,0} <- Int32.of_int (i*size+j) in
 	let indice i j= let pos =4*( j+i*(size-1) )  in
			 pos    <= (i,j) ;
			(pos+1) <= (i+1,j) ;
			(pos+2) <= (i+1,j+1) ;
			(pos+3) <= (i,j+1)  
        in
	  gridIter (size-1) (size-1) indice;
	  a

let gridHeat size=
	let a=arrayf (size*size) 1 in
	let heat i j= let pos=i*size+j in a.{pos,0}<- Random.float 1. in
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

let bGrid=BufferGl.create 0x8892 vertex 0x88E0
let bHeat=BufferGl.create 0x8892 heat 0x88E0

let bIndex=BufferGl.create 0x8893 index 0x88E0



let lGrid=VertexArray.getLoc ~prog ~name:"pos";;
let lHeat=VertexArray.getLoc ~prog ~name:"heat";;

VertexArray.withBuffer ~loc:lGrid bGrid;;
VertexArray.withBuffer ~loc:lHeat bHeat;;

let diffusion dt =
	let pos i j=i*size + j in
	let laplace pos=  4.*.heat.{pos,0} -. heat.{pos+1,0} -. heat.{pos-1,0} -.  heat.{pos+size,0} -. heat.{pos - size,0} in
	let evolve a= for i=1 to size-2 do (
			 for j=1 to (size-2) do (
				let pos=pos i j in
				 a.{pos,0} <- heat.{pos,0}  -. dt*. (laplace pos)
			 ) done 
		) done 
	and copy a i j = let pos = pos i j in heat.{pos,0}<- a.{pos,0} in
	let aux a=
	 	evolve a; gridIter size size (copy a) in
	BufferGl.update bHeat aux
		
let dt=0.01

let rec loop () = Rgl.clear 0x00004000; diffusion dt ;  Draw.elementsWith ~buf:bIndex ~primitives:0x0007 ~start:0 ~len:(BufferGl.size bIndex) ; Sdlgl.swap_buffers();
	match Sdlevent.poll() with
	    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
	    | Some Sdlevent.QUIT -> ()
	    | _ ->  loop();;

loop();
Sdl.quit();;


