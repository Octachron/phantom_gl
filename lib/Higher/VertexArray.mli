
type loc = [`VertexArray] Handle.t


val getLoc : prog:Program.t -> string ->  loc  
val enable :  loc -> unit
val disable :  loc -> unit

val withBuffer : ?normalized:bool -> loc:loc-> ('a,'b, [`Array]) BufferGl.t -> Overarray.layout -> unit

