

type loc = int

let uid x  =x 

let getLoc ~prog ~name = Rgl.getAttribLocation (Program.uid prog) name

let enable loc= Rgl.enableVertexAttribArray loc
let disable loc = Rgl.disableVertexAttribArray loc




let withBuffer ?normalized:(norm=false)  ~loc  buffer slice=
  BufferGl.bind buffer;
  enable loc;
  let open Slice in Rgl.vertexAttribPointer (uid loc) (slice.nElements) (BufferGl.baType buffer) norm slice.stride slice.offset;
  BufferGl.unbind buffer
 
