#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform vec2 u_resolution;
uniform float u_progress;

float rand(float n){return fract(sin(n) * 43758.5453123);}

float noise(float p){
	float fl = floor(p);
    float fc = fract(p);
	return mix(rand(fl), rand(fl + 1.0), fc);
}

//CC_Texture0
void main()
{
    vec2 uv = v_texCoord;
	vec2 screenPos = (gl_FragCoord.xy / u_resolution);

    //float time = CC_Time[2];

    const float distanceBetween = 0.1;
    const float distanceBetweenhalf = distanceBetween * 0.5;
    const float waveFreq = 50.0;
    const float waveFreq2 = 70.0;
    const float waveIntensityMax = 0.05;

    float y = screenPos.y;

    float ySin1 = sin(y * waveFreq) * waveIntensityMax;
    float ySin2 = sin(y * waveFreq2) * waveIntensityMax;

    float ySin = (ySin1 * 0.5) + (ySin2 * 0.5);

    float targetX = u_progress + ySin + (((y * 2.0) - 1.0));

    // 
    float dist = distance(min(targetX, screenPos.x), targetX);

    vec4 sample;
    sample = texture2D(CC_Texture0, uv);
    float rawSampleA = sample.a;

    // If the distance is close to the line, or passed the point of it, start blending against the line
    if(dist < 0.05 && rawSampleA > 0.001){
        float withinDist = distance(dist, 0.025) / 0.025;

        float barA = 1.0 - (pow(withinDist, 0.65));
        vec4 barResult = vec4(1.0, 1.0, 1.0, 1.0) * barA;
        if(dist < 0.025){
            sample *= (1.0 - barA);
            sample += barResult;
        }
        else{
            sample = barResult;
        }
    }
    // If it's ahead of the line, show nothing
    else{
        sample *= 0.0;
    }

    gl_FragColor = sample;
}