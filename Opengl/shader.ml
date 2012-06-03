
type 'a t = int 

let uid sh = sh

let createVert ()= GlM.rglShaderCreate(0)
let createFrag ()= GlM.rglShaderCreate(1)  

let load  = GlM.rglShaderLoad  
let compile = GlM.rglShaderCompile

let loadAndCompile s sh= load sh s; compile sh 

let compileVertFrom s = 
 let sh=createVert() in
 loadAndCompile s sh; sh 

let compileFragFrom s = 
 let sh=createFrag() in
 loadAndCompile s sh; sh 
