open FunOp

type 'a named = {x:'a; uid : int}

let uid {uid;_}=uid

let withName prog name x= let uid = GlM.rglGetUniformLocation (Program.uid prog) name in
{x;uid}

type _ t = 
	| Scalar : float named -> float t
	| Vec3 : Vector.t named -> Vector.t t 
	| Join : 'a t * 'b t -> ('a * 'b) t

let vsplit f v= Vector.(f v.x v.y v.z)

let rec send  : type a. a t -> unit= function
| Scalar {x;uid} -> GlM.rglUniform1f uid x
| Vec3 {x;uid} ->     vsplit <> GlM.rglUniform3f <| uid <| x
| Join (u1,u2) -> send u1; send u2 

let rec update :type a. a t-> a -> a t=fun u x ->
match u with
| Scalar s -> let n= Scalar {s with x} in send n; n
| Vec3 s -> let n= Vec3 {s with x} in send n; n
| Join (a,b) -> let (xa,xb)= x in Join (update a xa , update b xb) 

let rec content: type a. a t -> a=function
| Scalar {x;_} -> x
| Vec3 {x;_} -> x
| Join (a,b) -> content a, content b


let ( =$ ) = update

let (=~) u f = (update u) <> f <> content 

let scalar prog name x=Scalar (withName prog name x)
let vector prog name x=Vec3 (withName prog name x)
let join u1 u2  =Join(u1,u2)

module Archaic=
struct
type ('a,'b) t= {x:'a; uid:'b; send:'b->'a->unit}

let create send prog name x=let uid = GlM.rglGetUniformLocation (Program.uid prog) name in
{x;uid;send}

let join u1 u2= { x=u1.x,u2.x; uid=u1.uid,u2.uid; send= ( fun (id1,id2) (x1,x2) ->( u1.send id1 x1; u2.send id2 x2) ) }

let ( =$ ) u nex=
u.send u.uid nex; {u with x=nex}

let (=~) u f = let y=f u.x in
u =$ y

let scalar=create GlM.rglUniform1f

let vsplit f v= Vector.(f v.x v.y v.z)
let vector=create  ( vsplit <> GlM.rglUniform3f )  

let content u = u.x
let uid u = u.uid

end

module type UniformContent =
sig
  type t
  val send : int->t -> unit
end 


module Gen= functor(X : UniformContent) ->
struct
type t={ x:X.t; uid:int }
let create prog name x= let uid = GlM.rglGetUniformLocation (Program.uid prog) name in
{x;uid}

let ( =$ ) u nex=
X.send u.uid nex; {u with x=nex}

let (=~) u f = let y=f u.x in
u =$ y

end

module ScalarCont=
struct
type t=float 
let send=GlM.rglUniform1f
end

module Scalar = Gen(ScalarCont)
