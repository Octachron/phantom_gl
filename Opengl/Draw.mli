val clear : ([> `BufferBit] GlEnum.t) -> unit

val elementsWith : buf:('a,'b) BufferGl.t -> primitives:[`Primitives] GlEnum.t -> ?start:int-> len:int -> unit


val arrays : primitives:([`Primitives] GlEnum.t) -> ?start:int ->  len:int -> unit


