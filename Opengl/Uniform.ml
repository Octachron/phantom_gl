open FunOp

type ('a,'b) t= {x:'a; uid:'b; send:'b->'a->unit}

let create send prog name x=let uid = Rgl.getUniformLocation (Program.uid prog) name in
{x;uid;send}

let send {x; uid; send} = send uid x 
let update u nex= let neu={ u with x=nex} in send u; neu
let content u= u.x
let uid u = u.uid

let ( =$ ) = update

let (=~) u f = let y=f u.x in
u =$ y

let join u1 u2= { x=u1.x,u2.x; uid=u1.uid,u2.uid; send= ( fun (id1,id2) (x1,x2) ->( u1.send id1 x1; u2.send id2 x2) ) }




let vsplit3 f v= Vec3.(f v.x v.y v.z)
let vsplit2 f v=Vec2.(f v.x v.y)

let scalar=create Rgl.uniform1f
let vec2=create  ( Vec2.vsplit <> Rgl.uniform2f ) 
let vec3=create  ( Vec3.vsplit <> Rgl.uniform3f )  
 
module type WithUniform =sig
type t
val uniform : int ->t -> unit
end

let from (type s)
(module A : WithUniform with type t=s ) =  create (A.uniform)


module Gadt=
struct
type 'a named = {x:'a; uid : int}

let uid {uid;_}=uid

let withName prog name x= let uid = Rgl.getUniformLocation (Program.uid prog) name in
{x;uid}

type _ t = 
	| Scalar : float named -> float t
	| Vec3 : Vec3.t named -> Vec3.t t 
	| Join : 'a t * 'b t -> ('a * 'b) t

let vsplit f v= Vec3.(f v.x v.y v.z)

let rec send  : type a. a t -> unit= function
| Scalar {x;uid} -> Rgl.uniform1f uid x
| Vec3 {x;uid} ->     vsplit <> Rgl.uniform3f <| uid <| x
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
let vec3 prog name x=Vec3 (withName prog name x)
let join u1 u2  =Join(u1,u2)
end 


module type UniformContent =
sig
  type t
  val send : int->t -> unit
end 


module Gen= functor(X : UniformContent) ->
struct
type t={ x:X.t; uid:int }
let create prog name x= let uid = Rgl.getUniformLocation (Program.uid prog) name in
{x;uid}

let ( =$ ) u nex=
X.send u.uid nex; {u with x=nex}

let (=~) u f = let y=f u.x in
u =$ y

end

module ScalarCont=
struct
type t=float 
let send=Rgl.uniform1f
end

module Scalar = Gen(ScalarCont)
