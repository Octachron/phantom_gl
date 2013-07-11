#version 130

uniform mat4 Proj;
uniform mat3 Rot;

in vec2 pos;
in float heat;
out float oHeat;


void main(void)
{
    vec3 shift=vec3(0,0.5, -2);
    float z= - (heat+1.5 );
    vec3 v= Rot*(vec3(pos,z)- shift) +shift;
    v.z=z;
    gl_Position=Proj*vec4(v,1) ;
    oHeat=heat;	
}
