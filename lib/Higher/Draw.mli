val clear : <kind:[`BufferBit];.. > GlEnum.t -> unit

val enable : <kind:[`Enable];.. > GlEnum.t -> unit

val elementsWith : buf:('a,'b, [`Element]) BufferGl.t -> ?start:int-> len:int -> unit


val arrays : primitives:<kind:[`Primitives];..> GlEnum.t -> ?start:int ->  len:int -> unit


