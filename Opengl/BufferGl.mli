
type ('a,'b) t

val baType : ('a,'b) t -> int
val dims : ('a,'b) t -> int*int
val size : ('a,'b) t -> int

val bind : ('a,'b) t -> unit
val unbind : ('a,'b) t -> unit

val create : [`BufferType] GlEnum.t -> ('a,'b, Bigarray.c_layout) Bigarray.Array2.t -> [`BufferUseType] GlEnum.t -> ('a,'b) t

(*
val map : int -> ('a,'b) t -> ('a,'b,Bigarray.c_layout) Bigarray.Array2.t
val unmap : ('a,'b) t -> unit
*)

val update : ('a,'b) t ->  ?access:[`Access] GlEnum.t ->  (('a,'b, Bigarray.c_layout) Bigarray.Array2.t -> unit)-> unit
