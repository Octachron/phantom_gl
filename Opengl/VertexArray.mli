
type loc

val uid :  loc -> int
val getLoc : prog:Program.t -> name:string ->  loc  
val enable :  loc -> unit
val disable :  loc -> unit

val withBuffer : ?normalized:bool -> loc:loc-> ('a,'b) BufferGl.t -> Slice.t -> unit

