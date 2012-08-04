
type 'a t= {x:'a; uid:int; send:int->'a->unit}

let create send prog name x=let uid = GlM.rglGetUniformLocation (Program.uid prog) name in
{x;uid;send}


let ( =$ ) u nex=
u.send u.uid nex; {u with x=nex}

let (=~) u f = let y=f u.x in
u =$ y

let scalar=create GlM.rglUniform1f

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