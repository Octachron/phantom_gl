
external glewInit : unit -> unit ="rglGlewInit" 
external shaderCreate : int -> int = "rglShaderCreate" 

external shaderLoad : int-> string -> unit = "rglShaderLoad"

external shaderCompile : int -> unit = "rglShaderCompile"
external shaderDelete : int -> unit = "rglShaderDelete"

external programCreate : unit -> int ="rglProgramCreate"
external programAttach : int -> int -> unit = "rglProgramAttach"
external programLink : int -> unit = "rglProgramLink"
external programUse : int -> unit = "rglProgramUse"
external programDelete : int -> unit = "rglProgramDelete"

external getUniformLocation : int -> string -> int  = "rglGetUniformLocation"

external uniform1f : int -> float -> unit = "rglUniform1f"
external uniform3f : int -> float -> float -> float-> unit = "rglUniform3f"

(*Vertex Array *)
external getAttribLocation : int -> string->int "rglGetAttribLocation"
external enableVertexAttribArray : int -> unit "rglEnableVertexAttribArray"
external disableVertexAttribArray : int -> unit "rglDisableVertexAttribArray"
external vertexAttribPointer : int -> int -> int ->int -> int-> int->unit "rglVertexAttribPointer"

(* Buffer *)

external genBuffer : unit -> int = "rglGenBuffer"
external bindBuffer : int -> int -> unit = "rglBindBuffer"
external unbindBuffer : int -> unit = "rglUnbindBuffer"
external bufferData : int -> int -> ('a,'b,Bigarray.c_layout) Bigarray.Array2.t ->int-> unit
external mapBufferRange : int -> int -> int -> int -> ('a,'b,Bigarray.c_layout) Bigarray.Array2.t 
external unmapBuffer : unit -> unit

(* texture *)
external genTexture : unit -> int  = "rglGenTexture"

external bindTexture : int-> int -> unit  = "rglBindTexture"

external texParameteri : int-> int->int -> unit  = "rglBindTexture"
