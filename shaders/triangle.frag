#version 130
uniform float alpha;
in vec4 vColor;

void main(void)
{
    gl_FragColor = alpha*vColor;
}
