#version 120
uniform float mist;

void main(void)
{
    gl_Position=gl_Vertex;
    gl_FrontColor = (vec4(mist)+ gl_Color)/2;
}
