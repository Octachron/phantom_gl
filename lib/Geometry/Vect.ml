open FunOp


exception IncorrectDimension of (int*int)
let assertDim dimA dimB = if ( dimA <> dimB) then raise ( IncorrectDimension (dimA,dimB) )

module type Dim=
sig
	val dim : int
end



module type Abstraction = functor ( D : Dim ) ->
sig
type 'a t 
type vector = [`Vect] t
type matrix = [`Matrix] t

val dim : int

val print : 'a t -> unit
val raw  : 'a t -> float array
val ( @ ) : vector -> int ->  float
val ( @@ ) : matrix -> (int*int) ->  float

val vector : float array -> vector 
val gen :   (int->float) -> vector
val const :  float -> vector 

val zero : vector
val canon : int ->  vector

val matrix : float array -> matrix
val matrixGen : (int->int->float) -> matrix
val matrixConst : float -> matrix

val matrixGen2 : (int -> vector ) -> matrix


val id : matrix


val (  +: ) : 'a t -> 'a t -> 'a t 
val (  -: ) : 'a t -> 'a t -> 'a t 
val (  *: ) : float-> 'a t -> 'a t 
val (  /: ) : 'a t -> float->  'a t
val ( <*> ) : 'a t -> 'a t -> float 

val norm2 : 'a t -> float
val norm :  'a t -> float
val normalised : 'a t -> 'a t

val proj : 'a t -> 'a t -> 'a t 

val transposed : matrix -> matrix
val line : matrix-> int -> vector

val ( |: ) : matrix -> vector -> vector
val ( |:| ) : matrix -> matrix -> matrix

  
end



module With : Abstraction  = functor ( D : Dim ) ->
struct
type 'a t= float array
type vector  = [`Vect] t
type matrix  = [`Matrix] t


let dim=D.dim
let len = Array.length

let print v= 
let print_a o a = Printf.fprintf o "%f" a.(0); for i=1 to (len v) -1 do Printf.fprintf o ",%f" a.(i) done  in
Printf.printf "(%a)" print_a v

let raw x = x
let ( @ ) v i = v.(i)
let  ( @@ ) m (i,j)= m.(i*dim +j)



let vector : float array -> [`Vect] t = fun x ->  assertDim (Array.length x) dim; x
let unsafe_vector : float array -> [`Vect] t = fun x ->  x
let matrix : float array -> [`Vect] t = fun x ->  assertDim (Array.length x) (dim*dim); x


let unsafe_gen :   int->(int->float) -> 'a  t=Array.init
let gen :   (int->float) -> [`Vect] t=Array.init D.dim
let const :  float -> [`Vect] t = fun c ->  Array.make dim c

let zero  =const 0.
let canon = fun k ->  gen (fun i -> if k=i then 1. else 0. ) 

let matrixGen : (int->int->float) -> [`Matrix] t = fun  f ->  Array.init (dim * dim) (fun i -> f (i/dim) (i mod dim) ) 
let matrixConst : float -> [`Matrix] t = fun  c ->  Array.make (dim * dim) c

let matrixGen2 : (int -> [`Vect] t) -> [`Matrix] t = fun f -> matrixGen (fun i  j -> (f i).(j)  )

let id = matrixGen2 canon 

let mapOp : (float->float->float) -> 'a t -> 'a t -> 'a t  = fun op a b -> unsafe_gen (len a) (fun i ->  op a.(i) b.(i) )

let reduce :('a -> float->float -> 'a) -> 'a -> 'b t -> 'b t -> 'a = fun op e a b ->
let acc =ref e in
for i=0 to (len a) -1 do acc := ( op (!acc) a.(i) b.(i) ) done;
!acc 

let (  +: ) x y=mapOp (+.) x y
let (  -: )x y =mapOp (-.) x y
let (  *: ) s x= Array.map ( ( *. )  s ) x
let (  /: ) v s= Array.map (fun x -> x /.  s ) v
let ( <*> ) x y=reduce  (fun acc x x' -> acc+. x*.x') 0. x y



let norm2 : 'a t -> float   = fun v -> v <*>  v
let norm :  'a t -> float   = fun x ->  sqrt<| norm2 x 
let normalised : 'a t -> 'a t  = fun v ->  v/: (norm v)

let proj : 'a t -> 'a t -> 'a t = fun p v -> (v <*> p ) *: p 

let transposed x = matrixGen (fun i j -> x.(i + dim*j))
let line m i = unsafe_vector( Array.sub m (i*dim) dim )

(* let ( |: )  m v = gen (fun i -> (line m i) <*> v ) *)
let ( |: )  m v = gen (fun i ->  let s = ref 0. in for j=0 to dim-1 do s:= !s +. m.(i*dim+j)*.v.(j) done; !s )

let ( |:| )  m n = matrixGen (fun i j ->  let s = ref 0. in for k=0 to dim-1 do s:= !s +. m.(i*dim+k)*.n.(k*dim + j) done; !s )

end


