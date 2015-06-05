open Bigarray
open FunOp

type array

type _ kind = Array : [`Array] kind | Element : <kind:[`Primitives]> GlEnum.t -> [`Element] kind

type ('a,'b, 'c) t= {kind: 'c kind; id : [`Buffer] Handle.t; nEl : int ; baType : int}


let glKind0 : type a. a kind -> <kind:[`BufferType]> GlEnum.t= function
| Array -> GlEnum.array_buffer
| Element p ->  GlEnum.element_buffer

let glKind : type k. ('a,'b, k) t -> <kind:[`BufferType]> GlEnum.t  = fun b -> glKind0 b.kind

let glPrim { kind= Element p; _ }  = p

let size b= b.nEl
let dims b=b.nEl
let baType b=b.baType 

let bind: type k. ('a,'b, k) t -> unit = fun b ->  Rgl.bindBuffer (glKind b) b.id
let bindTo : type k. ('a,'b, k) t -> <kind:[>`BufferType]> GlEnum.t -> unit=  fun b target -> Rgl.bindBuffer target b.id
let unbind: type k. ('a,'b, k) t -> unit = fun b -> Rgl.unbindBuffer  (glKind b)
let unbindFrom = Rgl.unbindBuffer


let withBindedBuffer target buffer susp= lazy ( bindTo buffer target; ~:susp ; unbindFrom target )
let withBuffer b susp= lazy ( bind b;  ~: susp; unbind b )


let create usage kind data=
	let id=Rgl.genBuffer() in
        let b= { kind;id; nEl= Array1.dim data ; baType=Bits.baType data } in
	let _= bind b; Rgl.bufferData (glKind b) data usage; unbind b   in
	b

let createElements ?use:(use=GlEnum.stream_draw) prim data= create use (Element prim) data
let createArray ?use:(use=GlEnum.stream_draw) data  = create use Array data


let write buffer offset nEl data = 
	let open Bits in 
	let sizeEl= sizeOf buffer.baType in
		bind buffer;  Rgl.bufferSubData (glKind buffer) (offset*sizeEl) (nEl*sizeEl) data ; unbind buffer 

let writeTo offset nEl data buffer =  write buffer offset nEl data 

let map access b=
bind b;
let arr=Rgl.mapBuffer (glKind b) access b.baType b.nEl in
 arr

let unmap b= Rgl.unmapBuffer (glKind b); unbind b

let update b ?access:(access=GlEnum.rw) f= let a = map (GlEnum.raw access) b in f a ; unmap b 

let partialCopy source target startS startT nEl=
	let b=Bits.sizeOf source.baType in
	let bstartS=Bits.(startS*b) and bstartT=Bits.(startT*b) and bsize=Bits.(nEl*b) in
	bindTo source GlEnum.copy_read_buffer; bindTo target GlEnum.copy_write_buffer;
		Rgl.copyBufferSubData GlEnum.copy_read_buffer GlEnum.copy_write_buffer bstartS bstartT bsize;
	unbindFrom GlEnum.copy_write_buffer; unbindFrom GlEnum.copy_read_buffer


let copy source target= partialCopy source target 0 0 (target.nEl) 
