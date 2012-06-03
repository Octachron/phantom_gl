
external glewInit : unit -> unit ="mglGlewInit" 
external rglShaderCreate : int -> int = "mglShaderCreate" 

external rglShaderLoad : int-> string -> unit = "mglShaderLoad"

external rglShaderCompile : int -> unit = "mglShaderCompile"
external rglShaderDelete : int -> unit = "mglShaderDelete"

external rglProgramCreate : unit -> int ="mglProgramCreate"
external rglProgramAttach : int -> int -> unit = "mglProgramAttach"
external rglProgramLink : int -> unit = "mglProgramLink"
external rglProgramUse : int -> unit = "mglProgramUse"
external rglProgramDelete : int -> unit = "mglProgramDelete"
