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

CAMLprim value mglShaderCreate(value type){
CAMLparam1(type);
unsigned int gltype=Int_val(type)==0?GL_VERTEX_SHADER:GL_FRAGMENT_SHADER;
unsigned int id=0;

id=glCreateShader(gltype);

if(id==0)
	perror("Shader creation failure \n");
	CAMLreturn (Val_int(id));
}

CAMLprim value mglShaderLoad(value id, value src){
CAMLparam2(id,src);
GLuint gid= Int_val(id);
const char* s=String_val(src);

glShaderSource(gid,1,&s,0);


CAMLreturn (Val_unit);


}

CAMLprim value mglShaderCompile(value mid){
	CAMLparam1(mid);

	GLuint gid=Int_val(mid);
	glCompileShader(gid);
	GLint compile_status=GL_TRUE;
	glGetShaderiv(gid,GL_COMPILE_STATUS,&compile_status);
if ( compile_status != GL_TRUE)
{
GLint sizeLog;  
glGetShaderiv(gid, GL_INFO_LOG_LENGTH, &sizeLog);
char* log= malloc((sizeLog+1) *sizeof(char) );
glGetShaderInfoLog(gid,sizeLog,&sizeLog,log);
perror(log);
free(log);
}
CAMLreturn(Val_unit);
}


CAMLprim value mglShaderDelete (value id){
CAMLparam1(id);
glDeleteShader(Int_val(id));
CAMLreturn(Val_unit);
}

/************************** 
Opengl program functions 
***************************/


CAMLprim value mglProgramCreate(value nil){
CAMLparam1(nil);
GLuint id = glCreateProgram();
CAMLreturn (Val_int(id));
}
CAMLprim value mglProgramDelete(value id) { 
CAMLparam1(id);
glDeleteProgram(Int_val(id));
CAMLreturn(Val_unit);
}

CAMLprim value mglProgramAttach (value idp, value ids){
CAMLparam2(idp,ids);
glAttachShader(Int_val(idp), Int_val(ids));
CAMLreturn(Val_unit);
}

CAMLprim value mglProgramLink(value mId){
CAMLparam1(mId);
GLuint id= Int_val(mId);
    glLinkProgram(id);
    int IsLinked;
    glGetProgramiv(id, GL_LINK_STATUS, &IsLinked);
       if(IsLinked == GL_FALSE)
       {
          GLint loglen=0;
          glGetProgramiv(id, GL_INFO_LOG_LENGTH, &loglen);

          char* log = (char*) malloc((loglen+1)*sizeof (char));
          glGetProgramInfoLog(id, loglen, &loglen, log);
          perror(log);
	  free (log);
       }
CAMLreturn(Val_unit);
}

CAMLprim value mglProgramUse(value id) {
CAMLparam1(id);
 glUseProgram(Int_val(id)); 
CAMLreturn(Val_unit);
 }



/************************** 
Opengl uniform functions 
***************************/
CAMLprim value mglGetUniformLocation(value program, value name){
  CAMLparam2(program,name);
  GLuint id=Int_val(program);
  char* s = String_val(name);
  GLuint ret=glGetUniformLocation(id,s);
  CAMLreturn(Val_int(ret));
}

CAMLprim value mglUniform1f(value mloc,value mx)
{
  CAMLparam2(mloc,mx);
  GLuint loc=Int_val(mloc);
  float x=Double_val(mx);
  glUniform1f(loc,x);
  CAMLreturn(Val_unit);
}

CAMLprim value mglUniform3f(value mloc, value mx, value my, value mz){
	CAMLparam4(mloc,mx,my,mz);
	GLuint loc=Int_val(mloc);
        float x=Double_val(mx),y=Double_val(my),z=Double_val(mz);
	glUniform3f(loc,x,y,z);
	CAMLreturn(Val_unit);
} 




