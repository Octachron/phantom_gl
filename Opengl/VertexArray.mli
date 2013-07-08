
type loc

val uid :  loc -> int
val getLoc : prog:Program.t -> string ->  loc  
val enable :  loc -> unit
val disable :  loc -> unit

val withBuffer : ?normalized:bool -> loc:loc-> ('a,'b) BufferGl.t -> Overlay.t -> unit

