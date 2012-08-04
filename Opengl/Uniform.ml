open FunOp
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
