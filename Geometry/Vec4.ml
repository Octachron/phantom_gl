open FunOp


module D3= struct let dim=3 end
include (Vect.With(D3))


let (ex,ey,ez, et) = canon 0, canon 1, canon 2, canon 3



(** Opengl interface function **)
let converter =let open Overlay in
 { read = ( fun reader -> gen reader );  
  write = ( fun writer v -> for i=0 to dim-1 do  writer i (v@i) done ) }




type ctype=Bigarray.float32_elt
type otype=float
let atype=Bigarray.float32

  
let vsplit  f v = f (v@0) (v@1) (v@2) (v@3)
let uniform =  vsplit -<- Rgl.uniform4f


