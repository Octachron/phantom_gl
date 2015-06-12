open Bigarray
open FunOp

type layout= {offset:int; stride:int; nElements :int}
let full k={offset=0; stride=k;nElements=k} 


type ('a, 'b) adaptor = {read : (int -> 'a) -> 'b; write : (int->'a->unit) ->'b->unit} 
type ('a,'b) view = {layout:layout; adaptor : ('a,'b) adaptor}

type ('a,'b,'c, 'd) t = { data : ('a,'b,'c) Array1.t; layout:layout; adaptor : ('a,'d) adaptor  }

let withView data view = {data; layout=view.layout; adaptor = view.adaptor }  

let changeView overA view = { overA with layout=view.layout; adaptor = view.adaptor }

let reader overA index= fun i ->  let s=overA.layout in overA.data.{s.stride*index +s.offset +i }
let writer overA index= fun i x -> let s=overA.layout in  overA.data.{s.stride*index +s.offset +i }<- x

let ( @! ) overA index = overA.adaptor.read (reader overA index)
let (<= ) overA (index, value) = overA.adaptor.write (writer overA index) value



let overArray data layout adaptor= {data;layout;adaptor}


module type A1_Adaptable=sig
	type s
	type otype
	type ctype
	val atype : (otype, ctype) kind
	val adaptor : (otype, s) adaptor 
	val dim: int
end



let fromList (type  el) (type otype) (type ctype) (module M : A1_Adaptable with type s=el and type otype=otype and type ctype=ctype ) (l: el list) =
let layout =full M.dim 
and n=List.length l in
let data=Array1.create M.atype c_layout (n*layout.stride) in
let overA = {data;layout; adaptor=M.adaptor } in
let _= List.fold_left (fun i x ->  overA <= (i,x) ; i+1) 0 l in
overA
 



