
type 'a t = int 

let uid sh = sh

let createVert ()= Rgl.shaderCreate(0)
let createFrag ()= Rgl.shaderCreate(1)  

let load  = Rgl.shaderLoad  
let compile = Rgl.shaderCompile

let loadAndCompile s sh= load sh s; compile sh 

let compileVertFrom s = 
 let sh=createVert() in
 loadAndCompile s sh; sh 

let compileFragFrom s = 
 let sh=createFrag() in
 loadAndCompile s sh; sh 
