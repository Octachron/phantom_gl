

type loc = int

let uid x  =x 

let getLoc ~prog name = Rgl.getAttribLocation (Program.uid prog) name

let enable loc= Rgl.enableVertexAttribArray loc
let disable loc = Rgl.disableVertexAttribArray loc




let withBuffer ?normalized:(norm=false)  ~loc  buffer slice= 
  let open BufferGl in
  let open Overlay in 
  bind buffer;
  enable loc;
  Rgl.vertexAttribPointer (uid loc) (slice.nElements) (baType buffer) norm  (slice.stride)  slice.offset;
  unbind buffer
 
