type program
val uid : program -> int

val genUid : unit -> program 
val attach : program -> vert:[`Vertex] Shader.t -> frag:[`Fragment] Shader.t -> unit
val link : program -> unit

val use : program -> unit

val create : vert:[`Vertex] Shader.t -> frag:[`Fragment] Shader.t -> program
