#version 120
uniform float mist;
uniform vec3 pos;

void main(void)
{
    vec4 pcam=vec4(0,0,-1-0.5*mist,0);
    vec4 pos=gl_Vertex+0.2*vec4(pos,0)-pcam;
    pos.x=pos.x/pos.z;
    pos.y=pos.y/pos.z; pos.z=pos.z/10;
    gl_Position=pos;	
    gl_FrontColor = gl_Color;
}
