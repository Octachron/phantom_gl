#version 130

uniform float theta;
in vec2 pos;
in float heat;
out float oHeat;
void main(void)
{
    float c=cos(theta);
    float s=sin(theta);
    float phi=0.5; 
    float cp=cos(phi);
    float sp=sin(phi);
    float z=0.5*heat+1;
    vec3 v=vec3(pos,z);
  //  v=vec3(c*v.x+s*v.y, -s*v.x + c*v.y,z);
  //  v=vec3(v.x,cp*v.y+sp*v.z,cp*v.z-sp*v.y);
    gl_Position=vec4(v.xy, v.z/2 , z);
    oHeat=heat;	
}
