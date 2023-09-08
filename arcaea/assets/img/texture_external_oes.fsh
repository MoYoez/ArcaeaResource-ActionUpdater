#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main(void)
{
    gl_FragColor = texture2D(externalTexture, v_texCoord);
}