#version 130

in vec3 pos;
in vec3 color;
out vec3 vColor;

uniform mat3 rot;
uniform mat4 proj;

void main(void)
{

    vec3 shift= vec3(0,0, -3 );
    vec4 pos2=   proj* vec4(shift+rot*(pos),1 );
    
    gl_Position= pos2;
    vColor=color;	
}
