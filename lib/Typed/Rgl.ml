

(* Init *)
external glewInit : unit -> unit ="rglGlewInit" 

(* Basic *)
external clear : <kind:[>`BufferBit];.. > GlEnum.t -> unit = "rglClear"
external enable : <kind:[>`Enable];.. > GlEnum.t -> unit = "rglEnable"

(* Shader *)
external shaderCreate : <kind:[>`ShaderType];..> GlEnum.t -> [>`Shader] Handle.t = "rglShaderCreate" 
external shaderLoad : [>`Shader] Handle.t -> string -> unit = "rglShaderLoad"
external shaderCompile : [>`Shader] Handle.t -> unit = "rglShaderCompile"
external shaderDelete : [>`Shader] Handle.t -> unit = "rglShaderDelete"

(* Program*)
external programCreate : unit -> [>`Program] Handle.t ="rglProgramCreate"
external programAttach : [>`Program] Handle.t -> [>`Shader] Handle.t -> unit = "rglProgramAttach"
external programLink : [>`Program] Handle.t -> unit = "rglProgramLink"
external programUse : [>`Program] Handle.t -> unit = "rglProgramUse"
external programDelete : [>`Program] Handle.t -> unit = "rglProgramDelete"

(* Uniforms *)
external getUniformLocation : [`Program] Handle.t  -> string -> [`Uniform] Handle.t  = "rglGetUniformLocation"

external uniform1f : [`Uniform] Handle.t -> float -> unit = "rglUniform1f"
external uniform2f : [`Uniform] Handle.t -> float -> float -> unit = "rglUniform2f"
external uniform3f : [`Uniform] Handle.t -> float -> float -> float-> unit = "rglUniform3f"
external uniform4f : [`Uniform] Handle.t -> float -> float -> float-> float -> unit = "rglUniform4f"



external uniformMatrix2fv : [`Uniform] Handle.t -> int -> int-> float array ->  unit = "rglUniformMatrix2fv"
external uniformMatrix3fv : [`Uniform] Handle.t -> int -> int-> float array ->  unit = "rglUniformMatrix3fv"
external uniformMatrix4fv : [`Uniform] Handle.t -> int -> int -> float array ->  unit = "rglUniformMatrix4fv"

(* Draw*)

external drawArrays : <kind:[>`Primitives];..> GlEnum.t -> int -> int -> unit = "rglDrawArrays"
external drawElements : <kind:[>`Primitives];..> GlEnum.t -> int-> int -> int -> unit = "rglDrawElements"

(*Vertex Attribute Array *)
external getAttribLocation : [>`Program] Handle.t -> string->[>`VertexArray] Handle.t="rglGetAttribLocation"
external enableVertexAttribArray : [>`VertexArray] Handle.t -> unit="rglEnableVertexAttribArray"
external disableVertexAttribArray : [>`VertexArray] Handle.t -> unit="rglDisableVertexAttribArray"
external vertexAttribPointer : [>`VertexArray] Handle.t -> int -> int ->bool -> Bits.t-> Bits.t ->unit="rglVertexAttribPointer_interp" "rglVertexAttribPointer"


(* Buffer *)
external genBuffer : unit -> [`Buffer] Handle.t = "rglGenBuffer"
external bindBuffer :  <kind:[>`BufferType];..> GlEnum.t -> [`Buffer] Handle.t -> unit = "rglBindBuffer"
external unbindBuffer : <kind:[>`BufferType];..> GlEnum.t-> unit = "rglUnbindBuffer"

(* Vertex Array Object *)
external genVAO : unit -> [`VAO] Handle.t = "rglGenVertexArray"
external bindVAO :  [`VAO] Handle.t -> unit = "rglBindVertexArray"
external deleteVAO :  [`VAO] Handle.t -> unit = "rglDeleteVertexArray"


external bufferData : <kind:[>`BufferType];..> GlEnum.t -> ('a,'b,Bigarray.c_layout) Bigarray.Array1.t -> <kind:[>`BufferUseType];..> GlEnum.t-> unit = "rglBufferData"
external bufferSubData : <kind:[>`BufferType];..> GlEnum.t -> Bits.t -> Bits.t-> ('a,'b,Bigarray.c_layout) Bigarray.Array1.t->  unit = "rglBufferSubData"

external mapBuffer : <kind:[>`BufferType];..> GlEnum.t -> int -> int -> int  -> ('a,'b,Bigarray.c_layout) Bigarray.Array1.t = "rglMapBuffer"
external unmapBuffer : <kind:[>`BufferType];..> GlEnum.t -> unit = "rglUnmapBuffer"
external copyBufferSubData : <kind:[>`BufferTargetCopyable];..> GlEnum.t -> <kind:[>`BufferTargetCopyable];..> GlEnum.t -> Bits.t -> Bits.t -> Bits.t -> unit = "rglCopyBufferSubData"

(* texture *) 
external genTexture : unit -> [> `Texture] Handle.t  = "rglGenTexture"
external bindTexture : int-> [> `Texture] Handle.t -> unit  = "rglBindTexture"
external texParameteri : int-> int->int -> unit  = "rglBindTexture"
