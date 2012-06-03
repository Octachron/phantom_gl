type program
val uid : program -> int

val create : unit -> program 

val attach : program -> [`Vertex] Shader.t -> [`Fragment] Shader.t -> unit
val link : program -> unit
val use : program -> unit

val rise : [`Vertex] Shader.t -> [`Fragment] Shader.t -> program
