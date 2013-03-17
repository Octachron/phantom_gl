
type loc 

val uid : 'a loc -> int
val getLoc : Program.t -> string -> [`Disabled] loc  
val enable : [`Disabled] loc -> [`Enabled] loc
val disable : [`Enabled] loc -> [`Disabled] loc

