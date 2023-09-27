#ifdef GL_ES
precision highp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform vec2 u_resolution;
uniform float u_progress;

//CC_Texture0
void main()
{
    const float range = 0.2;

    vec2 screenPos = (gl_FragCoord.xy / u_resolution);
    vec4 sample = texture2D(CC_Texture0, v_texCoord).rgba;

    float targetY = (1.0 - screenPos.y);
    if(u_progress < (targetY))
    {
        sample.rgba = vec4(0.0);
    }
    else
    {
        sample.rgba *= clamp(u_progress - targetY, 0.0, range) / range;
    }

    gl_FragColor = sample;
}