open FunOp;;
open Bigarray;;
	
Sdl.init [`VIDEO];;
let surface= Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF];;

Rgl.glewInit();;


let vecToArray a i v = let x,y,z=Vec3.(v.x,v.y,v.z) in
 a.{3*i} <- x; a.{3*i+1} <- y; a.{3*i+2} <- z 

let vecListToArray a = ignore <> ( List.fold_left (fun i v -> (vecToArray a i v; i+1) ) 0  )

let arrayfromVec3 l =
 let n = List.length l in
 let a=Bigarray.Array1.create Bigarray.float32 Bigarray.c_layout (3*n) in
vecListToArray a l; a

let vertex = 
 let open Vec3 in
 let z=zero in 
  Slice.fromList (module Vec3)  [z; {z with x=1.}; {z with y=1.} ] 
	

let colors=Array1.of_array float32 c_layout
	[|  1.;0.;0.;1.;
	    0.;1.;0.;1. ;  
	    0.;0.;1.;1. 
	 |]


let index=Array1.of_array int16_unsigned c_layout
	  [| 0 ; 1 ; 2  |] 

let srv=Utils.load "shaders/simple.vert"
let srf=Utils.load "shaders/simple.frag"

let vert= Shader.compileVertFrom srv
let frag= Shader.compileFragFrom srf

let prog=Program.create vert frag;;
Program.use prog;;

let bufferPos=BufferGl.create GlEnum.array vertex.Slice.data GlEnum.stream_draw
let bCol=BufferGl.create GlEnum.array colors GlEnum.stream_draw

let bIndex=BufferGl.create GlEnum.element index GlEnum.stream_draw



let posLoc=VertexArray.getLoc ~prog ~name:"pos";;
let colLoc=VertexArray.getLoc ~prog ~name:"color";;

let vPos= Slice.({stride=0;offset=0;nElements=3})
let vCol= Slice.({stride=0;offset=0;nElements=4});;

VertexArray.withBuffer ~loc:posLoc bufferPos vPos;;
VertexArray.withBuffer ~loc:colLoc bCol vCol;;

BufferGl.update bCol (fun a -> a.{1}<- 1. );;

let rec loop () = Draw.clear GlEnum.(color++depth);  Draw.elementsWith ~buf:bIndex ~primitives:GlEnum.triangles ~start:0 ~len:3 ; Sdlgl.swap_buffers();
	match Sdlevent.poll() with
	    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
	    | Some Sdlevent.QUIT -> ()
	    | _ ->  loop();;

loop();
Sdl.quit();;


