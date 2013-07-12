
type ('a,'b) t

val baType : ('a,'b) t -> int
(* val dims : ('a,'b) t -> int *)
val size : ('a,'b) t -> int

val bind : ('a,'b) t -> unit
val unbind : ('a,'b) t -> unit

val create : <kind:[`BufferType];..> GlEnum.t -> ('a,'b, Bigarray.c_layout) Bigarray.Array1.t -> <kind:[`BufferUseType];..>  GlEnum.t -> ('a,'b) t

val write : ('a,'b) t -> int -> int ->  ('a,'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
val writeTo : int -> int ->  ('a,'b, Bigarray.c_layout) Bigarray.Array1.t ->  ('a,'b) t ->  unit

(*
val map : int -> ('a,'b) t -> ('a,'b,Bigarray.c_layout) Bigarray.Array1.t
val unmap : ('a,'b) t -> unit
*)

val update : ('a,'b) t ->  ?access:<kind:[`Access]> GlEnum.t ->  (('a,'b, Bigarray.c_layout) Bigarray.Array1.t -> unit)-> unit
