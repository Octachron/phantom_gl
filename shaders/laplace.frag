#version 130

in float oHeat;


float fluct(float rate, float val){
	return mod(rate*val,1);
}

vec4 colorize(float h){
	return vec4( fluct(3, h), fluct (1, h) , fluct(2.,h) , 1) ; 
}

void main(void)
{
    gl_FragColor = colorize(oHeat);
}
