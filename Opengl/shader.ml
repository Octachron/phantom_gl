
type 'a t = [`Shader] Handle.t

let untype sh = sh

let createVert ()= Rgl.shaderCreate GlEnum.vertex_shader
let createFrag ()= Rgl.shaderCreate GlEnum.fragment_shader  

let load  = Rgl.shaderLoad  
let compile = Rgl.shaderCompile

let loadAndCompile s sh= load sh s; compile sh 

let compileVertFrom s = 
 let sh=createVert() in
 loadAndCompile s sh; sh 

let compileFragFrom s = 
 let sh=createFrag() in
 loadAndCompile s sh; sh 
