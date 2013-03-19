#include <GL/glew.h>
#include <GL/gl.h>

#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/bigarray.h>
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


unsigned int sizes[10]= {sizeof(float), sizeof(double), sizeof(char), sizeof(char), 0,0,sizeof(int), sizeof(long), sizeof(int), sizeof(int) } ;




CAMLprim void rglBufferData(value targetType, value array, value usage ){
//CAMLparam3(targetType, array, usage );
GLenum c_target= Int_val(targetType);
GLenum c_use=Int_val(usage);
struct caml_ba_array* uarr= Bigarray_val(array);
int type = uarr->flags | BIGARRAY_KIND_MASK;
intnat* dims = uarr->dim;
void* data= uarr-> data;

glBufferData(c_target, dims[0]*dims[1]*sizes[type],data,c_use);
return;
}

CAMLprim value rglMapBuffer(value target,value access, value type, value xdim, value ydim){
CAMLparam5(target,access,type, xdim, ydim);
GLenum c_target=Int_val(target);
GLenum c_access = Int_val(access);

unsigned int c_xdim=Int_val(xdim), c_ydim=Int_val(ydim);
unsigned int c_type= Int_val(type);

void* p = glMapBuffer(c_target, c_access);
intnat dims[2]={c_xdim,c_ydim};
value V=alloc_bigarray( c_type | BIGARRAY_C_LAYOUT, 2,p, dims);
CAMLreturn(V);  
}


CAMLprim void rglUnmapBuffer(value target){
CAMLparam1(target);
GLenum c_target=Int_val(target);
glUnmapBuffer(c_target);
return;
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




