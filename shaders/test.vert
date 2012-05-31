#version 120

attribute vec2 coord;
varying vec2 pos;
void main(void)
{
    gl_Position=vec4(coord,0,1);
    pos=coord;
}
