
type loc

val uid :  loc -> int
val getLoc : prog:Program.t -> name:string ->  loc  
val enable :  loc -> unit
val disable :  loc -> unit

val withBuffer : ?normalized:bool -> ?stride:int-> ?offset:int ->loc:loc-> ('a,'b) BufferGl.t  -> unit

