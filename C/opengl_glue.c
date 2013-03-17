#include <GL/glew.h>
#include <GL/gl.h>

#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <stdio.h>

CAMLprim value rglGlewInit(value unit){
CAMLparam1(unit);
glewInit();
CAMLreturn(Val_unit);
}

CAMLprim value rglShaderCreate(value type){
CAMLparam1(type);
unsigned int gltype= (Int_val(type)==0)?GL_VERTEX_SHADER:GL_FRAGMENT_SHADER;
unsigned int id=0;

id=glCreateShader(gltype);

if(id==0)
	perror("Shader creation failure \n");
	CAMLreturn (Val_int(id));
}

CAMLprim value rglShaderLoad(value id, value src){
CAMLparam2(id,src);
GLuint gid= Int_val(id);
const char* s=String_val(src);

glShaderSource(gid,1,&s,0);


CAMLreturn (Val_unit);


}

CAMLprim value rglShaderCompile(value mid){
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


CAMLprim value rglShaderDelete (value id){
CAMLparam1(id);
glDeleteShader(Int_val(id));
CAMLreturn(Val_unit);
}

/************************** 
Opengl program functions 
***************************/


CAMLprim value rglProgramCreate(value nil){
CAMLparam1(nil);
GLuint id = glCreateProgram();
CAMLreturn (Val_int(id));
}
CAMLprim value rglProgramDelete(value id) { 
CAMLparam1(id);
glDeleteProgram(Int_val(id));
CAMLreturn(Val_unit);
}

CAMLprim value rglProgramAttach (value idp, value ids){
CAMLparam2(idp,ids);
glAttachShader(Int_val(idp), Int_val(ids));
CAMLreturn(Val_unit);
}

CAMLprim value rglProgramLink(value mId){
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

CAMLprim value rglProgramUse(value id) {
CAMLparam1(id);
 glUseProgram(Int_val(id)); 
CAMLreturn(Val_unit);
 }



/************************** 
Opengl uniform functions 
***************************/
CAMLprim value rglGetUniformLocation(value program, value name){
  CAMLparam2(program,name);
  GLuint id=Int_val(program);
  char* s = String_val(name);
  GLuint ret=glGetUniformLocation(id,s);
  CAMLreturn(Val_int(ret));
}

CAMLprim value rglUniform1f(value mloc,value mx)
{
  CAMLparam2(mloc,mx);
  GLuint loc=Int_val(mloc);
  float x=Double_val(mx);
  glUniform1f(loc,x);
  CAMLreturn(Val_unit);
}

CAMLprim value rglUniform3f(value mloc, value mx, value my, value mz){
	CAMLparam4(mloc,mx,my,mz);
	GLuint loc=Int_val(mloc);
        float x=Double_val(mx),y=Double_val(my),z=Double_val(mz);
	glUniform3f(loc,x,y,z);
	CAMLreturn(Val_unit);
} 


/****
Vertex Array
*****/



CAMLprim value rglGetAttribLocation(value prog, value name){
CAMLparam2(prog,name);
GLuint cprog= Int_val(prog);
const char* s=String_val(name);

int loc= glGetAttribLocation(cprog, s);

if (loc == -1){
printf("Vertex array not found : %s \n", s);
}


CAMLreturn (Val_int(loc));
}


CAMLprim void rglEnableVertexAttribArray(value id){
GLuint loc = Int_val(id);
glEnableVertexAttribArray(loc);
return;
}

CAMLprim void rglDisableVertexAttribArray(value id){
GLuint loc = Int_val(id);
glDisableVertexAttribArray(loc);
return;
}


CAMLprim void rglVertexAttribPointer(value index, value size, value type, value normalized, value stride,value offset ){
//CAMLparam5(index,size,type,normalized,stride);
//CAMLxparam1(offset);
GLuint c_index = Int_val(index), c_size=Int_val(size), c_type= Int_val(type), c_norm=Int_val(normalized), c_stride=Int_val(stride), c_offset=Int_val(offset) ;
glVertexAttribPointer(c_index,c_size,c_type, c_norm, c_stride, NULL+c_offset );
return;
}


/****
Buffer
******/

CAMLprim value rglGenBuffer(value nil){
CAMLparam1(nil);
GLuint id=0;
glGenBuffers(1, &id);
CAMLreturn(Val_int(id));
}


CAMLprim void rglBindBuffer(value type, value id){
//CAMLparam2(type,id);
GLuint c_id=Int_val(id);
GLuint c_type=Int_val(type);
glBindBuffer(c_type,c_id);
return ;
}

CAMLprim void rglUnbindBuffer(value type){
//CAMLparam1(type);
GLuint c_type=Int_val(type);
glBindBuffer(c_type,0);
return ;
}




/*****
Texture
******/

CAMLprim value rglGenTexture(value nil){
CAMLparam1(nil);
GLuint id=0;
glGenTextures(1, &id);
CAMLreturn(Val_int(id));
}

CAMLprim void rglBindTexture(value type, value id){
//CAMLparam2(type,id);
GLuint cid= Int_val(id);
GLuint ctype = Int_val(type);
glBindTexture(ctype,cid);
return;
}

CAMLprim void rglTexParameteri(value type, value parameter, value val){
GLuint cparameter= Int_val(parameter);
GLuint ctype = Int_val(type);
GLuint cval = Int_val(val);


glTexParameteri(ctype,cparameter,cval);
return;
}




