#version 120

uniform vec3 pos;

void main(void)
{
    vec4 pos=gl_Vertex+0.2*vec4(pos,0);
    pos.x=pos.x/pos.z;
    pos.y=pos.y/pos.z; pos.z=pos.z/10;
    gl_Position=pos;	
    gl_FrontColor = gl_Color;
}
