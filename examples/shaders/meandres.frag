#version 330

in vec2 pos_2;
uniform float[48] xs;

float ncos(float x){
return (1+ cos (x-0.5) )/2;
}

float fluct(float rate, float val){
	return ncos( rate * val );
}

float peak(int k, float x){
  float nc = 6.;
  return 1 - nc * clamp( abs(x - k/nc ), 0, 1/nc );
}

vec4 colorize(float h){
  float r = peak(1,h) + peak(4,h) + peak( 5,h) + peak(6,h);
  float b = peak(1,h) + peak(2,h) + peak(6,h);
  float m = abs(h-0.5);
  float g = peak(3,h) + peak(4,h) + peak(6,h); 
	return vec4( r, g , b, 1) ; 
}



vec4 colorize2(float h){
  float r = 2 * ( clamp(h,0.5,1) - 0.5 );
  float b = 2 * (0.5 - clamp(h,0,0.5) );
  float m = abs(h-0.5);
  float g = 1 - 2 * m; 
	return vec4( r, g , b, 1) ; 
}

float meandre(int i,vec2 v) {
  return sin ( xs[3*i] * v.x + xs[3*i+1] * v.y + xs[3*i+2] );
}

float meandres(vec2 v, float[48] xs) {
  float x = 0;
  int n = 3;
  int m = 3;
  float y = 0;
  for(int i =0;i<n;++i) {
    y=1;
    for (int j=0;j<m;++j)
      y *= meandre(m*i + j , v ); 
    x+=  2*y;
  }
  return ( (1 + sin(x)) /2 );
}


void main(void)
{
    gl_FragColor = colorize(meandres(pos_2,xs));
}
