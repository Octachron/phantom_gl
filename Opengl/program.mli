type program
val uid : program -> int

val create : unit -> program 

val attach : program -> vert:[`Vertex] Shader.t -> frag:[`Fragment] Shader.t -> unit
val link : program -> unit
val use : program -> unit

val rise : vert:[`Vertex] Shader.t -> frag:[`Fragment] Shader.t -> program
