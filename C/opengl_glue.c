#include <GL/glew.h>
#include <GL/gl.h>

#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/bigarray.h>
#include <stdio.h>



/***
Translation tables
***/

unsigned long sizes[10]= {sizeof(float), sizeof(double), sizeof(char), sizeof(char), sizeof(short),sizeof(unsigned short),sizeof(int), sizeof(long), sizeof(int), sizeof(int) } ;

unsigned int gltypes[10]= {GL_FLOAT, GL_DOUBLE,GL_BYTE,GL_UNSIGNED_BYTE,GL_SHORT,GL_UNSIGNED_SHORT, GL_INT,GL_INT, GL_INT, GL_INT } ;

unsigned int glutypes[10]= {GL_FLOAT, GL_DOUBLE,GL_BYTE,GL_UNSIGNED_BYTE,GL_UNSIGNED_SHORT,GL_UNSIGNED_SHORT, GL_UNSIGNED_INT,GL_UNSIGNED_INT, GL_UNSIGNED_INT, GL_UNSIGNED_INT } ;



/****
Init
****/

CAMLprim value rglGlewInit(value unit){
CAMLparam1(unit);
glewInit();
CAMLreturn(Val_unit);
}

/***
Basic
***/
CAMLprim void rglClear(value w){
int cw=Int_val(w);
glClear(cw);
return;
}


CAMLprim void rglEnable(value w){
int cw=Int_val(w);
glEnable(cw);
return;
}

/***
Shader functions
****/

CAMLprim value rglShaderCreate(value type){
CAMLparam1(type);
CAMLlocal1(oid);
unsigned int gltype= (Int_val(type)==0)?GL_VERTEX_SHADER:GL_FRAGMENT_SHADER;
unsigned int id=0;

id=glCreateShader(gltype);
oid=Val_int(id);
if(id==0)
	perror("Shader creation failure \n");
	
	CAMLreturn (oid);
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

CAMLprim void rglUniform2f(value mloc, value mx, value my){
	GLuint loc=Int_val(mloc);
        float x=Double_val(mx),y=Double_val(my);
	glUniform2f(loc,x,y);
	return; 
} 

CAMLprim value rglUniform3f(value mloc, value mx, value my, value mz){
	CAMLparam4(mloc,mx,my,mz);
	GLuint loc=Int_val(mloc);
        float x=Double_val(mx),y=Double_val(my),z=Double_val(mz);
	glUniform3f(loc,x,y,z);
	CAMLreturn(Val_unit);
} 


CAMLprim value rglUniform4f(value mloc, value mx, value my, value mz,value mt){
	CAMLparam5(mloc,mx,my,mz,mt);
	GLuint loc=Int_val(mloc);
        float x=Double_val(mx),y=Double_val(my),z=Double_val(mz),t=Double_val(mt);
	glUniform4f(loc,x,y,z,t);
	CAMLreturn(Val_unit);
} 



CAMLprim value rglUniformMatrix2fv(value oLoc, value oCount, value oTranspose, value oArray){
	CAMLparam4(oLoc,oCount, oArray, oTranspose);
	GLuint loc=Int_val(oLoc), count =Int_val(oCount); 
	GLboolean transpose=Int_val(oTranspose);
	double* p =&Double_field(oArray,0); float* converted = malloc(count*4*sizeof(float));
	int i; for( i= 0;i<count*4;++i) converted[i] = p[i] ;
	glUniformMatrix2fv(loc,count, transpose, converted );
	free(converted);
	CAMLreturn(Val_unit);
} 

CAMLprim value rglUniformMatrix3fv(value oLoc, value oCount, value oTranspose, value oArray){
	CAMLparam4(oLoc,oCount, oArray, oTranspose);
	GLuint loc=Int_val(oLoc), count =Int_val(oCount); 
	GLboolean transpose=Int_val(oTranspose);
	double* p =&Double_field(oArray,0); float* converted = malloc(count*9*sizeof(float));
	int i; for( i= 0;i<count*9;++i) converted[i] = p[i] ;
	glUniformMatrix3fv(loc,count, transpose, converted );
	free(converted);	
	CAMLreturn(Val_unit);
} 


CAMLprim value rglUniformMatrix4fv(value oLoc, value oCount, value oTranspose, value oArray){
	CAMLparam4(oLoc,oCount, oArray, oTranspose);
	GLuint loc=Int_val(oLoc), count =Int_val(oCount); 
	GLboolean transpose=Int_val(oTranspose);
	double* p =&Double_field(oArray, 0 ); float* converted = malloc(count*16*sizeof(float));
	int i; for( i= 0;i<count*16;++i) converted[i] = p[i] ;
	glUniformMatrix4fv(loc,count, transpose, converted );
	free(converted);
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

//printf("VertexAttribPointer\n");

GLuint c_index = Int_val(index), c_size=Int_val(size), o_type= Int_val(type), c_norm=Int_val(normalized), c_stride=Int_val(stride);

long c_offset=  Int_val(offset) ;

GLint c_type= gltypes[o_type]; 
//printf("loc=%d, size=%d, type=%d (%d), norm=%d, stride=%d, c_offset=%ld \n", c_index,c_size,c_type,GL_FLOAT, c_norm, c_stride,c_offset);
glVertexAttribPointer(c_index,c_size,c_type, c_norm, c_stride*sizes[o_type],  (void*) c_offset );
return;
}

CAMLprim void rglVertexAttribPointer_interp(int nargs, value* args){
rglVertexAttribPointer(args[0],args[1],args[2],args[3],args[4],args[5]);
}


/***
Draw
****/

CAMLprim void rglDrawArrays(value primitive, value start, value len ){
GLint c_prim=Int_val(primitive), c_start=Int_val(start), c_len=Int_val(len);
glDrawArrays(c_prim,c_start,c_len);
return; 
}


CAMLprim void rglDrawElements(value primitive,value type, value start, value len ){
GLint c_prim=Int_val(primitive), o_type=Int_val(type), c_start=Int_val(start), c_len=Int_val(len);
int c_type=glutypes[o_type];
size_t off=c_start*sizes[o_type];

//printf("Draw Elements ::  primitive:%d (%d), type:%d(%d), offset:%ld, len:%d \n", c_prim,GL_TRIANGLES,c_type,GL_INT,off,c_len);

glDrawElements(c_prim,c_len, c_type,(void*) (off) );
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







CAMLprim value baType(value array){
CAMLparam1(array);

int ctype = Bigarray_val(array)->flags & BIGARRAY_KIND_MASK;
//printf("ctype=%d \n",ctype);
//ctype= gltypes[ctype];

CAMLreturn(Val_int(ctype));
}


CAMLprim value sizeOf(value ctype){
CAMLparam1(ctype);

int s=sizes[Int_val(ctype)];
CAMLreturn(Val_int(s));
}




CAMLprim void rglBufferData(value targetType, value array, value usage ){
//CAMLparam3(targetType, array, usage );
GLenum c_target= Int_val(targetType);
GLenum c_use=Int_val(usage);
struct caml_ba_array* uarr= Bigarray_val(array);
int type = uarr->flags & BIGARRAY_KIND_MASK;
intnat* dims = uarr->dim;
void* data= uarr-> data;

//printf( "Buffer Data :: type=%d, target=%d (%d), size=%ld, use=%d (%d) \n", type, c_target,GL_ARRAY_BUFFER, dims[0]*sizes[type], c_use, GL_STREAM_DRAW);

glBufferData(c_target, dims[0]*sizes[type],data,c_use);
return;
}



CAMLprim void rglBufferSubData(value oKind, value oOffset, value oSize, value oArray){
//CAMLparam3(targetType, array, usage );
GLuint kind= Int_val(oKind), off=Int_val(oOffset), size=Int_val(oSize);

struct caml_ba_array* arr= Bigarray_val(oArray);
unsigned int type = arr->flags & BIGARRAY_KIND_MASK;

void* data= arr-> data;
GLintptr p_off= (GLintptr) ( off*sizes[type]);
glBufferSubData(kind, p_off,size*sizes[type],data);
return;
}


CAMLprim value rglMapBuffer(value target,value access, value type, value nel){
CAMLparam4(target,access,type, nel);
CAMLlocal1(V);
GLenum c_target=Int_val(target);
GLenum c_access = Int_val(access);

unsigned int c_nel=Int_val(nel);
unsigned int c_type= Int_val(type);

void* p = glMapBuffer(c_target, c_access);
intnat dims[1]={c_nel};

V=alloc_bigarray( c_type | BIGARRAY_C_LAYOUT, 1,p, dims);
CAMLreturn(V);  
}


CAMLprim void rglUnmapBuffer(value target){
//CAMLparam1(target);
GLenum c_target=Int_val(target);
glUnmapBuffer(c_target);
return;
}



CAMLprim void rglCopyBufferSubData(value oKindR, value oKindW,  value oOffsetR, value oOffsetW , value oSize){
//CAMLparam3(targetType, array, usage );
GLuint kindR= Int_val(oKindR), offR=Int_val(oOffsetR), kindW= Int_val(oKindW), offW=Int_val(oOffsetW),  size=Int_val(oSize);

GLintptr p_offR= (GLintptr) ( offR);
GLintptr p_offW= (GLintptr) ( offW);

glCopyBufferSubData(kindR, kindW,  p_offR, p_offW , size);
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




