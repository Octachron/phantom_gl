open Bigarray

type t= {offset:int; stride:int; nElements :int}


let full k={offset=0; stride=k;nElements=k} 

type ('a, 'b) conversion = {read : (int -> 'a) -> 'b; write : (int->'a->unit) ->'b->unit} 

type ('a,'b,'c, 'd) view = { data : ('a,'b,'c) Array1.t; slice: t; conversion : ('a,'d) conversion  }

let reader view index= fun i ->   view.data.{view.slice.stride*index +view.slice.offset +i }
let writer view index= fun i x -> let s=view.slice in  view.data.{s.stride*index +s.offset +i }<- x

let ( !! ) view index = view.conversion.read (reader view index)
let (<=) view (index,value)= view.conversion.write (writer view index) value

let view data slice conversion= {data;slice;conversion}


module type Convertible=sig
	type t
	type otype
	type ctype
	val atype : (otype, ctype) kind
	val converter : (otype, t) conversion 
	val adim: int
end

let fromList (type el) (type otype) (type ctype) (module M : Convertible with type t=el and type otype=otype and type ctype=ctype ) (l: el list) =
let slice =full M.adim 
and n=List.length l in
let data=Array1.create M.atype c_layout (n*slice.stride) in
let view = {data;slice; conversion=M.converter } in
 List.fold_left (fun i x ->  view <= (i,x) ; i+1) 0 l;
view
 