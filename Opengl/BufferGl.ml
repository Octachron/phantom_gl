open Bigarray
type ('a,'b) t= {target:int; id : int; nEl : int ; baType : int}

let size b= b.nEl
let dims b=b.nEl
let baType b=b.baType 

let bind b= Rgl.bindBuffer b.target b.id
let unbind b= Rgl.unbindBuffer b.target

let create target data usage=
	let id=Rgl.genBuffer() in
        let b= { target=GlEnum.raw target;id; nEl= Array1.dim data ; baType=Rgl.baType data } in
	bind b;
	Rgl.bufferData b.target data  (GlEnum.raw usage);
	unbind b; b


let map access b=
bind b;
let arr=Rgl.mapBuffer b.target access b.baType b.nEl in
 arr

let unmap b= Rgl.unmapBuffer b.target; unbind b

let update b ?access:(access=GlEnum.rw) f= let a = map (GlEnum.raw access) b in f a ; unmap b 
