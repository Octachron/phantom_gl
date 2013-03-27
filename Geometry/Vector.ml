open FunOp

module type Axioms=
sig
	type vect
	val zero : vect
	val (+) : vect -> vect -> vect
	val (-) : vect -> vect-> vect
	val ( * ) : float -> vect -> vect
	val ( / ) : vect -> float-> vect
	
	val ( *: ) : vect -> vect -> float 

	val print : vect -> unit
end



module Space = functor ( V : Axioms ) ->
struct

include(V)
let norm2 v = V.(v*:v)
let norm =  sqrt <> norm2 
 
let projection axe v= V.( (axe *: v) * axe )

let normalisation v= 
 let n= norm v in
(n,V.(v/n))

let normalized v= let n=norm v in V.(v/n)


type hyperplane = {normal : V.vect ; pos : float }


let hyperplane v p={normal=v; pos=p}

let (||) h v= V. ( h.normal *: v)  +. h.pos
let (|*) s h = {h with pos = s*. h.pos}  


let printH h=
let v=h.normal in
V.print v; Printf.printf ":%f" h.pos


end
