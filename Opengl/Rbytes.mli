open FunOp

type 'a t 


val (+) : 'a t -> 'a t -> 'a t
val (-) : 'a t -> 'a t -> 'a t
val ( * ) : int -> 'a t -> 'a t
val ( / ) : 'a t -> int -> 'a t


(* Bigarray type information*)
val baType : ('a,'b,'c) Bigarray.Array1.t -> int 
val sizeOf : int -> [`Byte] t 
val sizeOfElement : ('a,'b,'c) Bigarray.Array1.t -> [`Byte] t 
