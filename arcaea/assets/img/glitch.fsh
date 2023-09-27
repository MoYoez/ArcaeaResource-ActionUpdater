#ifdef GL_ES
precision highp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

float glitch_intensity = 1.0;

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

float Scale1 = 2.3;
float Scale2 = 3.5;
float Amp = 50.0;
float FreqX = 10.0;
float FreqY = 30.0;

mat3 m = mat3( 0.00,  0.80,  0.60,
              -0.80,  0.36, -0.48,
              -0.60, -0.48,  0.64 );

float fbm( vec3 p )
{
    float f;
    f  = 0.5000*noise( p ); p = m*p*2.02;
    f += 0.2500*noise( p ); p = m*p*2.03;
    f += 0.1250*noise( p ); p = m*p*2.01;
    f += 0.0625*noise( p ); 
    return f;
}

//CC_Texture0
void main()
{
    vec2 uv = v_texCoord;
	vec3 v;
	vec3 p = Scale2 * vec3(uv, 0.0) - CC_Time[2] * (1.0, 1.0, 1.0) * 0.1;
	float x = fbm(p);
	v = (0.5 + 0.5 * sin(x * vec3(FreqX, FreqY, 1.0) * Scale1)) / Scale1;
	v *= Amp;

    float distFromCenter = distance(vec2(0.5, 0.5), uv.xy);
    float distFromCenterInv = 1.0 - distFromCenter;
    const float distanceCutoff = 0.25;
    if(distFromCenter > distanceCutoff){
        distFromCenterInv -= ((distFromCenter - distanceCutoff) / distanceCutoff * 0.5);
        distFromCenterInv = clamp(distFromCenterInv, 0.0, 1.0);
    }

    distFromCenter = max(distFromCenter, 0.75);

    vec2 warpedUv = ((0.008) * v.xy) * (distFromCenter * clamp(abs((uv.y - 0.5)), 0.1, 1.0)) + uv;

    vec4 origTi = texture2D(CC_Texture0, uv).rgba;
    vec4 ti = texture2D(CC_Texture0, vec2(warpedUv.x, uv.y)).rgba;

    ti += (vec4(0.09,0.0,0.12,0) * ti.a * distFromCenterInv * 2.0);

    gl_FragColor = ti;
}