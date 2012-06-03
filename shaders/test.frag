#version 120

varying vec2 pos;

uniform float time;
uniform vec2 center;
uniform float zoom;
uniform float stripe;

vec2 f(vec2 z0,vec2 z)
{
    float r=z.x*z.x-z.y*z.y;
    float im=2*z.x*z.y;
    vec2 w= vec2(r,im);
return w+z0;
}



vec2 fractal(vec2 v, int n)
{

   vec2 w=f(v,v);
    for (int i=0;i<n-1;++i)
        w=f(v,w);
    return w;
}


vec4 colorize( vec2 v)
{
    float sti=0.0001*time;
    float xsh=cos(2*3.14*cos(sti));
    float ysh=cos(2*3.14*cos(2.1828*sti));
    float x=v.x+xsh;
    float y=v.y+ysh;
    float r=x*x+y*y;
    float vp=stripe;

    vec4 color=vec4(0,0,cos(vp*r),1);
    return color;
}


void main(void)
{

    vec2 coord=zoom*pos-vec2(0.5,0)+center;
    gl_FragColor = colorize(fractal(coord,101));
}
