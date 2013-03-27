open Bigarray
type ('a,'b) t= {target:int; id : int; dims : int * int; baType : int}

let size b= let m, n = b.dims in m*n
let dims b=b.dims
let baType b=b.baType 

let bind b= Rgl.bindBuffer b.target b.id
let unbind b= Rgl.unbindBuffer b.target

let create target data usage=
	let id=Rgl.genBuffer() in
        let b= {target;id; dims= (Array2.dim1 data, Array2.dim2 data) ; baType=Rgl.baType data } in
	bind b;
	Rgl.bufferData b.target data usage;
	unbind b; b


let map access b=
bind b;
let (xdim,ydim) =b.dims in
let arr=Rgl.mapBuffer b.target access b.baType xdim ydim in
 arr

let unmap b= Rgl.unmapBuffer b.target; unbind b

let update b ?access:(access=0x88BA) f= let a = map access b in f a ; unmap b 
