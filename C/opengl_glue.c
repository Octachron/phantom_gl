#include <GL/glew.h>
#include <GL/gl.h>

#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>

CAMLprim value mglGlewInit(value unit){
CAMLparam1(unit);
glewInit();
CAMLreturn(Val_unit);
}

CAMLprim value mglCreateShader(value type){
CAMLparam1(type);
unsigned int gltype=Int_val(type)==0?GL_VERTEX_SHADER:GL_FRAGMENT_SHADER;
unsigned int id=0;

id=glCreateShader(gltype);
if(id==0)
	printf("Shader creation failure \n");
	CAMLreturn (Val_int(id));
}
