open FunOp

let clear = Rgl.clear
let enable = Rgl.enable

let arrays ~primitives ?start:(start=0) ~len= Rgl.drawArrays primitives  start len 

let elementsWith ~buf  ?start:(start=0) ~len=
BufferGl.bind buf;
Rgl.drawElements (BufferGl.glPrim buf) (BufferGl.baType buf) start len;
BufferGl.unbind buf;; 
