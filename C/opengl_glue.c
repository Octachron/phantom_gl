#include <GL/glew.h>

#include <caml/memory.h>
#include <caml/mlvalues.h>

CAMLprim value mlGlewInit(value unit){
CAMLparam1(unit);
glewInit();
CAMLreturn(Val_unit);
}
