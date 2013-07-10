open FunOp

module D2= struct let dim=2 end
include (Vect.With(D2))



(** Opengl interface function **)
let converter =let open Overlay in
 { read = ( fun reader -> gen reader );  
  write = ( fun writer v -> for i=0 to dim-1 do  writer i (v@i) done ) }


type ctype=Bigarray.float32_elt
type otype=float
let atype=Bigarray.float32

let (ex,ey) = canon 0, canon 1


let vsplit  f v = f (v@0) (v@1)
let uniform =  vsplit -<- Rgl.uniform2f
