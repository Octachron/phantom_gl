
type 'a kind
type ('a,'b,'c) t

val baType : ('a,'b,'c) t -> int
(* val dims : ('a,'b) t -> int *)
val size : ('a,'b,'c) t -> int

val glKind :  ('a,'b,'c) t -> <kind:[`BufferType]> GlEnum.t
val glPrim :   ('a,'b,[`Element]) t -> <kind:[`Primitives]> GlEnum.t
 

val bind : ('a,'b,'c) t -> unit
val bindTo : ('a,'b,'c) t ->  <kind:[`BufferType]> GlEnum.t -> unit
val unbind : ('a,'b,'c) t -> unit
val unbindFrom : <kind:[`BufferType]> GlEnum.t -> unit

(*
 val create : 'c kind -> ('a,'b, Bigarray.c_layout) Bigarray.Array1.t -> <kind:[`BufferUseType];..>  GlEnum.t -> ('a,'b,'c) t
*)

val createArray : ?use:<kind:[`BufferUseType]>  GlEnum.t -> ('a,'b, Bigarray.c_layout) Bigarray.Array1.t  -> ('a,'b, [`Array]) t
val createElements : ?use:<kind:[`BufferUseType]>  GlEnum.t -> <kind:[`Primitives]> GlEnum.t -> ('a,'b, Bigarray.c_layout) Bigarray.Array1.t -> ('a,'b, [`Element]) t


(** write buffer offset nEl data *)
val write : ('a,'b,'c) t -> int -> int ->  ('a,'b, Bigarray.c_layout) Bigarray.Array1.t -> unit
val writeTo : int -> int ->  ('a,'b, Bigarray.c_layout) Bigarray.Array1.t ->  ('a,'b,'c) t ->  unit

val rewrite : buffer:('a,'b,'c) t ->  data:('a,'b, Bigarray.c_layout) Bigarray.Array1.t -> unit



(*
val map : int -> ('a,'b) t -> ('a,'b,Bigarray.c_layout) Bigarray.Array1.t
val unmap : ('a,'b) t -> unit
*)

val update : ('a,'b,'c) t ->  ?access:<kind:[`Access]> GlEnum.t ->  (('a,'b, Bigarray.c_layout) Bigarray.Array1.t -> unit)-> unit

val partialCopy : ('a,'b,'c) t -> ('a,'b,'c) t -> int -> int -> int -> unit
val copy :  ('a,'b,'c) t -> ('a,'b,'c) t -> unit
