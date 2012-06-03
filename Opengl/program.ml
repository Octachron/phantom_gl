type program =int
 
let uid p= p

let create = GlM.rglProgramCreate
let attach p shv shf = GlM.rglProgramAttach p (Shader.uid shv) ; GlM.rglProgramAttach p (Shader.uid shf) 
let link = GlM.rglProgramLink
let use =GlM.rglProgramUse

let rise shv shf = 
  let p =create() in
    attach p shv shf; link p; use p; p
