type t =int
 
let uid p= p

let genUid = Rgl.programCreate
let attach p ~vert ~frag = Rgl.programAttach p (Shader.uid frag) ; Rgl.programAttach p (Shader.uid vert) 
let link = Rgl.programLink
let use =Rgl.programUse

let create ~vert ~frag = 
  let p =genUid() in
    attach p vert frag; link p; use p; p
