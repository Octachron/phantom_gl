

type loc = int

let uid x  =x 

let getLoc ~prog ~name = Rgl.getAttribLocation (Program.uid prog) name

let enable loc= Rgl.enableVertexAttribArray loc
let disable loc = Rgl.disableVertexAttribArray loc

let withBuffer ?normalized:(norm=false) ?stride:(stride=0) ?offset:(off=0) ~loc  buffer=
  Printf.printf "WithBuffer \n";
  BufferGl.bind buffer;
  enable loc;
  Rgl.vertexAttribPointer (uid loc) (snd ( BufferGl.dims  buffer ) ) (BufferGl.baType buffer) norm stride off;
  BufferGl.unbind buffer
 
