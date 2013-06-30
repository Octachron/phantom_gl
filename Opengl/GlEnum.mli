
type 'a t 

val raw : 'a t -> int 


val byte : < kind: [`BufferType] > t

val array : <kind: [`BufferType]> t
val element : <kind: [`BufferType]>  t


val stream_draw : <kind: [`BufferUseType]>  t 
val stream_read : <kind: [`BufferUseType]>  t 
val stream_copy : <kind: [`BufferUseType]>  t 

val static_draw : <kind: [`BufferUseType]>  t 
val static_read : <kind: [`BufferUseType]>  t 
val static_copy : <kind: [`BufferUseType]>  t 

val dynamic_draw : <kind: [`BufferUseType]>  t
val dynamic_read : <kind: [`BufferUseType]>  t 
val dynamic_copy : <kind: [`BufferUseType]>  t


val depth :  <kind: [`BufferBit]; fusion : [`True]>  t
val stencil :  <kind: [`BufferBit]; fusion : [`True]>  t
val color :  <kind: [`BufferBit]; fusion : [`True]>  t

val depth_test: <kind:[`Enable];fusion:[`True]> t

val _true :  <kind: [`Bool]>  t
val _false : <kind: [`Bool]> t

val points : <kind: [`Primitives]>  t
val lines : <kind: [`Primitives]> t
val lines_loop : <kind: [`Primitives]> t
val lines_strip : <kind: [`Primitives]> t
val triangles : <kind: [`Primitives]> t
val triangles_loop : <kind: [`Primitives]> t
val triangles_strip : <kind: [`Primitives]> t
val quads : <kind: [`Primitives]> t

val read : <kind:[`Access]> t 
val write  : <kind:[`Access]> t 
val rw   : <kind:[`Access]> t 



val ( ++ ) : <fusion:[`True]; ..> t -> <fusion:[`True];..> t ->  <fusion:[`True]; ..> t 
