open FunOp


module D4= struct let dim=4 end
include (Vect.With(D4))


let (ex,ey,ez, et) = canon 0, canon 1, canon 2, canon 3



(** Opengl interface function **)


let vsplit  f v = f (v@0) (v@1) (v@2) (v@3)

module Gl=struct
let dim=dim
type ctype=Bigarray.float32_elt
type otype=float
type s=vector
let atype=Bigarray.float32

  

let uniform =  vsplit -<- Rgl.uniform4f


let converter =let open Overlay in
 { read = ( fun reader -> gen reader );  
  write = ( fun writer v -> for i=0 to dim-1 do  writer i (v@i) done ) }

end


module GlMat=struct
let converter =let open Overlay in
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

let uniform loc m = Rgl.uniformMatrix4fv loc 1  0 (raw m)

type s= [`Matrix] t
end




let perspective ?angle:(angle=0.5) ~near far=
	let d=  1./. tan (angle/.2.) and
	diff= near -.far in
	let zz= ( near+.far )/. diff and zt = 2.*. near*. far /. diff in
	matrix ([|d ; 0. ; 0. ; 0. ; 
		  0.; d  ; 0.  ; 0. ;
		  0.;  0. ; zz ; zt ;
		  0.;  0. ; -1. ; 0.|] )  
