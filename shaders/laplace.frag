#version 130

in float oHeat;


float ncos(float x){
return (1+ cos (x-0.5) )/2;
}

float fluct(float rate, float val){
	return ncos( pow(val,-rate) );
}

vec4 colorize(float h){
	return vec4( fluct(1, h), fluct (3, h) , fluct(2.,h) , 1) ; 
}

void main(void)
{
    gl_FragColor = colorize(oHeat);
}
