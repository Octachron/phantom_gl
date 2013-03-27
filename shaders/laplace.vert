#version 130

in vec3 pos;
in float heat;
out float oHeat;
void main(void)
{
    gl_Position=vec4(pos,1);
    oHeat=heat;	
}
