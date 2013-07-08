(* Init *)
external glewInit : unit -> unit ="rglGlewInit" 

(* Basic *)
external clear : int -> unit = "rglClear"
external enable : int -> unit = "rglEnable"

(* Shader *)
external shaderCreate : int -> int = "rglShaderCreate" 
external shaderLoad : int-> string -> unit = "rglShaderLoad"
external shaderCompile : int -> unit = "rglShaderCompile"
external shaderDelete : int -> unit = "rglShaderDelete"

(* Program*)
external programCreate : unit -> int ="rglProgramCreate"
external programAttach : int -> int -> unit = "rglProgramAttach"
external programLink : int -> unit = "rglProgramLink"
external programUse : int -> unit = "rglProgramUse"
external programDelete : int -> unit = "rglProgramDelete"

(* Uniforms *)
external getUniformLocation : int -> string -> int  = "rglGetUniformLocation"

external uniform1f : int -> float -> unit = "rglUniform1f"
external uniform2f : int -> float -> float -> unit = "rglUniform2f"
external uniform3f : int -> float -> float -> float-> unit = "rglUniform3f"
external uniform4f : int -> float -> float -> float-> float -> unit = "rglUniform4f"

(* Draw*)

external drawArrays : int -> int -> int -> unit = "rglDrawArrays"
external drawElements : int -> int-> int -> int -> unit = "rglDrawElements"

(*Vertex Array *)
external getAttribLocation : int -> string->int="rglGetAttribLocation"
external enableVertexAttribArray : int -> unit="rglEnableVertexAttribArray"
external disableVertexAttribArray : int -> unit="rglDisableVertexAttribArray"
external vertexAttribPointer : int -> int -> int ->bool -> int-> int->unit="rglVertexAttribPointer_interp" "rglVertexAttribPointer"

(* Buffer *)

external genBuffer : unit -> int = "rglGenBuffer"
external bindBuffer : int -> int -> unit = "rglBindBuffer"
external unbindBuffer : int -> unit = "rglUnbindBuffer"

external baType : ('a,'b,'c) Bigarray.Array1.t -> int = "rglBaType"
external bufferData : int -> ('a,'b,Bigarray.c_layout) Bigarray.Array1.t ->int-> unit = "rglBufferData"
external mapBuffer : int -> int -> int -> int  -> ('a,'b,Bigarray.c_layout) Bigarray.Array1.t = "rglMapBuffer"
external unmapBuffer : int -> unit = "rglUnmapBuffer"

(* texture *)
external genTexture : unit -> int  = "rglGenTexture"
external bindTexture : int-> int -> unit  = "rglBindTexture"
external texParameteri : int-> int->int -> unit  = "rglBindTexture"
