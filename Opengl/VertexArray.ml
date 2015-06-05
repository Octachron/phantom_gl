

type loc = [`VertexArray] Handle.t


let getLoc ~prog name = Rgl.getAttribLocation prog name

let enable loc= Rgl.enableVertexAttribArray loc
let disable loc = Rgl.disableVertexAttribArray loc



type ('a,'b,'c,'k) t= {loc:loc; buffer: ('a,'b,'k) BufferGl.t; view: ('a,'c) Overarray.view } 

type ('a,'b) desc = { name : string; nEl: int }



let withBuffer ?normalized:(norm=false)  ~loc  buffer layout= 
  let open BufferGl in
  let open Overarray in 
  let otype = baType buffer in
  let open Bits in
  let elSize= sizeOf otype in
  let stride= layout.stride * elSize 
  and offset=layout.offset  * elSize in
  bind buffer;
  enable loc;
  Rgl.vertexAttribPointer loc layout.nElements otype norm stride offset;
  unbind buffer
 
