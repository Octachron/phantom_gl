
type 'a t 

val raw : 'a t -> int 


val byte : [`DataType] t

val array : [`BufferType] t
val element : [`BufferType] t


val stream_draw : [`BufferUseType] t 
val stream_read : [`BufferUseType] t 
val stream_copy : [`BufferUseType] t 

val static_draw : [`BufferUseType] t 
val static_read : [`BufferUseType] t 
val static_copy : [`BufferUseType] t 

val dynamic_draw : [`BufferUseType] t
val dynamic_read : [`BufferUseType] t 
val dynamic_copy : [`BufferUseType] t


val depth :  [` BufferBit | `Fusion] t
val stencil :  [` BufferBit | `Fusion] t
val color :  [` BufferBit | `Fusion] t

val _true : [`Bool] t
val _false : [`Bool] t

val points : [`Primitives] t
val lines : [`Primitives] t
val lines_loop : [`Primitives] t
val lines_strip : [`Primitives] t
val triangles : [`Primitives] t
val triangles_loop : [`Primitives] t
val triangles_strip : [`Primitives] t
val quads : [`Primitives] t

val read : [`Access] t 
val write  : [`Access] t 
val rw   : [`Access] t 



val ( ++ ) : [> `Fusion] t -> [> `Fusion] t ->  [> `Fusion] t 
