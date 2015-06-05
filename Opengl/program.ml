type t = [`Program] Handle.t
 

let gen = Rgl.programCreate
let attach p ~vert ~frag = Rgl.programAttach p (Shader.untype frag) ; Rgl.programAttach p (Shader.untype vert) 
let link = Rgl.programLink
let use =Rgl.programUse

let create ~vert ~frag = 
  let p =gen() in
    attach p vert frag; link p; use p; p
