type t = [`Program] Handle.t

val gen : unit -> t 
val attach : t -> vert:[`Vertex] Shader.t -> frag:[`Fragment] Shader.t -> unit
val link : t -> unit

val use : t -> unit

val create : vert:[`Vertex] Shader.t -> frag:[`Fragment] Shader.t -> t
