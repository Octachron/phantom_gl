#version 130

in vec3 pos;
in vec4 color;
out vec4 vColor;
void main(void)
{
    gl_Position=vec4(pos,1);
    vColor=color;	
}
