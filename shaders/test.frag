#version 120

uniform float mist;
void main(void)
{

    gl_FragColor =gl_Color+vec4((1+mist)/2,0,0,0) ;
}
