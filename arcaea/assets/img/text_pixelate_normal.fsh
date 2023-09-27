#ifdef GL_ES
precision highp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
varying vec4 v_outPos;

uniform vec4 u_effectColor;
uniform vec4 u_textColor;
uniform vec4 params;
uniform int u_characterIndex;
uniform int u_targetIndex;
uniform float u_targetTime;

float glitch_intensity = 1.0;

 
float rand(float n){return fract(sin(n) * 43758.5453123);}

vec4 effect(vec2 uv, vec4 color)
{
    float r = rand(float(u_characterIndex));
    float v = CC_Time[2] + params[0] - r + float(u_characterIndex);

    const float effect_length = 0.5;
    float power = effect_length - clamp(CC_Time[1] - u_targetTime, 0.0, effect_length);
    if (u_characterIndex - u_targetIndex == 0 && power > 0.0) 
    {
        float dx = 0.01 * (power * 2.5);
        float dy = 0.01 * (power * 2.5);
        uv = vec2(dx * (floor(uv.x / dx) + 0.5),
                  dy * (floor(uv.y / dy) + 0.5));

        vec2 direction = glitch_intensity * vec2(1.0,0);
        float modValueX = 0.000137 + rand(v - mod(v, 0.00053));
        float yPoint = (uv.y - mod(uv.y, modValueX));
        float adjustedPointX = mod(rand(yPoint), 0.137);
        uv.x += glitch_intensity * (adjustedPointX);
        color = v_fragmentColor * vec4(u_textColor.rgb,
                                        u_textColor.a * texture2D(CC_Texture0, uv).a);
    }
    return color;
}

void main()
{
    vec4 sample = v_fragmentColor * vec4(u_textColor.rgb,// RGB from uniform\n
                                         u_textColor.a * texture2D(CC_Texture0, v_texCoord).a
    );
    
    vec4 col = effect(v_texCoord, sample);
    gl_FragColor = col;
}