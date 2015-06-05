open AMask
open Nlist2
open FunOp

let a = nat [| 1; 2 ;3;4 |]

let m = mask {stride=2;offset=0}

let b = a @>@ m

let () = print_int <|  foldl (+) 0 b



