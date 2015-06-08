open FunOp


module D3= struct let dim=3 end
include (Vect.With(D3))


let (ex,ey,ez) = canon 0, canon 1, canon 2

let ( ^: ) v w  = vector ([| (v@1)*.(w@2) -. (v@2) *. (w@1); (v@2)*.(w@0) -. (v@0) *. (w@2); (v@0)*.(w@1) -. (v@1) *. (w@0); |])

let rotation ax t v= 
	let p = proj ax v in
	(cos(t) *: (v-:p) +: p+:  sin(t) *: (ax ^: v)) 


let rmatrix ax t = matrixGen2 (rotation ax t -<- canon)

let vsplit  f v = f (v@0) (v@1) (v@2)

(** Opengl interface function **)
module Gl=struct
let adaptor =let open Overarray in
 { read = gen ;  
  write = ( fun writer v -> for i=0 to dim-1 do  writer i (v@i) done ) }

type ctype=Bigarray.float32_elt
type otype=float
let atype=Bigarray.float32

 let dim=dim 

let uniform =  vsplit -<- Rgl.uniform3f

type s= [`Vect] t
end


module GlMat=struct
let adaptor =let open Overarray in
 { read = matrix -<- ( Array.init (dim*dim) ) ;  
  write = ( fun writer v -> 
	for i=0 to dim-1 do
		for j=0 to dim-1 do 
			writer (i*dim+j) (v@@(i,j) ) 
		done 
	done ) }

type ctype=Bigarray.float32_elt
type otype=float
let atype=Bigarray.float32

 let dim=dim*dim 

let uniform loc m = Rgl.uniformMatrix3fv loc 1  0 (raw m)

type s= [`Matrix] t
end
