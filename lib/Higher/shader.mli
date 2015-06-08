type 'a t
val untype : 'a t -> [`Shader] Handle.t

val createVert :  unit -> [`Vertex] t
val createFrag : unit -> [`Fragment] t

val load : 'a t -> string -> unit
val compile : 'a t -> unit

val compileVertFrom : string -> [`Vertex] t
val compileFragFrom : string -> [`Fragment] t 
