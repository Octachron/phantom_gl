
let arrays ~primitives ?start:(start=0) ~len= Rgl.drawArrays primitives start len 

let elementsWith ~buf ~primitives ?start:(start=0) ~len=
BufferGl.bind buf;
Rgl.drawElements primitives (BufferGl.baType buf) start len;
BufferGl.unbind buf;; 
