open FunOp;;

	
Sdl.init [`VIDEO];;
let surface= Sdlvideo.set_video_mode ~w:500 ~h:500 ~bpp:0 [`OPENGL; `DOUBLEBUF];;

Rgl.glewInit();;




let vecToArray a i v = Vec3.( a.{i,0} <- v.x; a.{i,1} <- v.y; a.{i,2} <- v.z )
let vecListToArray a = ignore <> ( List.fold_left (fun i v -> (vecToArray a i v; i+1) ) 0  )

let arrayfromVec3 l =
 let n = List.length l in
 let a=Bigarray.Array2.create Bigarray.float32 Bigarray.c_layout n 3 in
vecListToArray a l; a

let vertex = 
 let open Vec3 in let
 z=Vec3.zero in 
 arrayfromVec3 Vec3.( [z; {z with x=1.}; {z with y=1.} ] )
	

let colors=Bigarray.Array2.of_array Bigarray.float32 Bigarray.c_layout
	[| [|1.;0.;0.;1.|]; [|0.;1.;0.;1.|]; [|0.;0.;1.;1.|]  |]


let index=Bigarray.Array2.of_array Bigarray.int16_unsigned Bigarray.c_layout
	  [| [|0|] ;[|1|] ; [|2|]  |] 

let srv=Utils.load "shaders/simple.vert"
let srf=Utils.load "shaders/simple.frag"

let vert= Shader.compileVertFrom srv
let frag= Shader.compileFragFrom srf

let prog=Program.create vert frag;;
Program.use prog;;

let bufferPos=BufferGl.create GlEnum.array vertex GlEnum.stream_draw
let bCol=BufferGl.create GlEnum.array colors GlEnum.stream_draw

let bIndex=BufferGl.create GlEnum.element index GlEnum.stream_draw



let posLoc=VertexArray.getLoc ~prog ~name:"pos";;
let colLoc=VertexArray.getLoc ~prog ~name:"color";;

VertexArray.withBuffer ~loc:posLoc bufferPos;;
VertexArray.withBuffer ~loc:colLoc bCol;;

BufferGl.update bCol (fun a -> a.{0,1}<- 1. );;

let rec loop () = Draw.clear GlEnum.(color ++ depth);  Draw.elementsWith ~buf:bIndex ~primitives:GlEnum.triangles ~start:0 ~len:3 ; Sdlgl.swap_buffers();
	match Sdlevent.poll() with
	    | Some Sdlevent.KEYDOWN { Sdlevent.keysym = Sdlkey.KEY_ESCAPE }
	    | Some Sdlevent.QUIT -> ()
	    | _ ->  loop();;

loop();
Sdl.quit();;


