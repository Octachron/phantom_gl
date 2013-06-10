#version 130

uniform float theta;
in vec2 pos;
in float heat;
out float oHeat;
void main(void)
{
    float c=cos(theta);
    float s=sin(theta); 
    float z=heat+1;
    vec3 v=vec3(pos,z);
    v=vec3(c*v.x+s*v.y, -s*v.x + c*v.y,z);
    gl_Position=vec4(v.xy, v.z/2 , v.z);
    oHeat=heat;	
}
