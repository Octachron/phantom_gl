type program =int
 
let uid p= p

let create = GlM.rglProgramCreate
let attach p ~vert ~frag = GlM.rglProgramAttach p (Shader.uid frag) ; GlM.rglProgramAttach p (Shader.uid vert) 
let link = GlM.rglProgramLink
let use =GlM.rglProgramUse

let rise ~vert ~frag = 
  let p =create() in
    attach p vert frag; link p; use p; p
