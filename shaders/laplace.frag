#version 130

in float oHeat;


float fluct(float rate, float val){
	return (pow(cos(rate*val),2));
}

vec4 colorize(float h){
	return vec4( fluct(1, h), fluct (22, h) , fluct(0.13,h) , 1) ; 
}

void main(void)
{
    gl_FragColor = colorize(oHeat);
}
