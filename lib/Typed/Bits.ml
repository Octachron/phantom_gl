open FunOp

type t = int


let (+) a b  = a + b
let (-) a b  = a - b
let ( * ) a b  = a * b
let ( / ) a b = a / b


(* Bigarray type information*)
external baType : ('a,'b,'c) Bigarray.Array1.t -> int = "baType"
external sizeOf : int ->  t = "sizeOf"
let sizeOfElement  x = sizeOf (baType x)
