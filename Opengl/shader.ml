
type 'a shader = int 

let uid sh = sh

let createVert ()= GlM.rglCreateShader(0)
let createFrag ()= GlM.rglCreateShader(1)  
