#ifdef GL_ES
precision highp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform vec4 params;
uniform vec4 aberration_direction_norm;

float rand(float n){return fract(sin(n) * 43758.5453123);}

// float noise(float p){
// 	float fl = floor(p);
//     float fc = fract(p);
// 	return mix(rand(fl), rand(fl + 1.0), fc);
// }

vec3 hueShift(vec3 Color, float Shift)
{
    vec3 P = vec3(0.55735)*dot(vec3(0.55735),Color);
    vec3 U = Color-P;
    vec3 V = cross(vec3(0.55735),U);    
    Color = U*cos(Shift*6.2832) + V*sin(Shift*6.2832) + P;
    return vec3(Color);
}

void main(void)
{
    // don't both unpacking these?
    float glitch_intensity = params.x;
    float aberration_intensity = params.y;
    float hue_progress = params.z;
    float desat_intensity = params.w;

    vec2 samplePoint = v_texCoord;   
    vec2 direction = vec2(0,0);
    {
        // glitch
        direction = glitch_intensity * vec2(0.001,0);
        float modValueX = 0.00137 + rand(CC_Time[1] - mod(CC_Time[1], 0.053));
        float yPoint = (samplePoint.y - mod(samplePoint.y, modValueX));
        float adjustedPointX = mod(rand(yPoint), 0.0137);
        samplePoint.x += glitch_intensity * (adjustedPointX * 3.0);
    }

    vec4 orig = texture2D(CC_Texture0, samplePoint + direction);
    
    {
        // aberration
        float aberrationAmount = 0.01 * aberration_intensity;
        vec2 aberrated = aberration_direction_norm.xy * aberrationAmount;
        vec4 left = texture2D(CC_Texture0, samplePoint - aberrated);
        vec4 right = texture2D(CC_Texture0, samplePoint + aberrated);
        orig.r = left.r;
        orig.b = right.b;
    }

    {
        // hue
        orig.rgb = hueShift(orig.rgb, hue_progress);
    }

    {
        // desat
        float L = 0.3*orig.r + 0.6*orig.g + 0.1*orig.b;
        orig.r += desat_intensity * (L - orig.r);
        orig.g += desat_intensity * (L - orig.g);
        orig.b += desat_intensity * (L - orig.b);
    }

    gl_FragColor = vec4(orig.rgb,1.0);
}
