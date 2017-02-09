#version 330

in vec2 pos;
out vec2 pos_2;

void main(void)
{
    gl_Position=vec4(pos,0,1);
    pos_2=pos;	
}
