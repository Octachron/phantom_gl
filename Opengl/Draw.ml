open FunOp

let clear x = Rgl.clear (GlEnum.raw x)
let enable x = Rgl.enable (GlEnum.raw x)

let arrays ~primitives ?start:(start=0) ~len= Rgl.drawArrays (GlEnum.raw primitives)  start len 

let elementsWith ~buf ~primitives ?start:(start=0) ~len=
BufferGl.bind buf;
Rgl.drawElements (GlEnum.raw primitives) (BufferGl.baType buf) start len;
BufferGl.unbind buf;; 
