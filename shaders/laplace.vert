#version 130

uniform float theta;
in vec2 pos;
in float heat;
out float oHeat;


    float n=1;
    float f=100;
    float d= 1/ (tan(0.5) );
    mat4 Proj = mat4(d,0,0, 0,
                     0,d,0, 0,
                     0, 0, (n+f)/(n-f), -1,
		     0, 0,  2*n*f/(n-f) , 0 );



void main(void)
{
    float z= - (heat+2 );
    vec4 v=vec4(pos,z,1);
    gl_Position=Proj*v;
    oHeat=heat;	
}
