#ifdef GL_ES
precision highp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float min_effect_intensity;
uniform float max_effect_intensity; // Range between 6.0(on) and 15.0(off)
uniform float overall_effect_strength;
uniform vec4 texture_bounds;
uniform int sample_count;

const float blur = 0.175;

void main(void)
{
    float effect_intensity = mix(min_effect_intensity, max_effect_intensity, overall_effect_strength);
    vec2 xOnlyTextureCord = vec2(v_texCoord.x, v_texCoord.y * 0.667);
    vec2 direction = -(normalize(xOnlyTextureCord - 0.5));

    vec2 velocity = vec2(direction * blur * pow(length(xOnlyTextureCord - 0.5), effect_intensity));
    float inverseSampleCount = 1.0 / float(sample_count);

    // https://www.shadertoy.com/view/4tlyD8
    // Transverse Chromatic Aberration

    mat3 increments = mat3(
        vec3(velocity * 1.0 * inverseSampleCount, 0),
        vec3(velocity * 2.0 * inverseSampleCount, 0),
        vec3(velocity * 6.0 * inverseSampleCount, 0)
    );
    vec3 accumulator = vec3(0);
    mat3 offsets = mat3(0); 
    
    for (int i = 0; i < sample_count; i++) {
        accumulator.r += texture2D(CC_Texture0, clamp(v_texCoord + offsets[0].xy, texture_bounds.xy, texture_bounds.zw)).r;
        accumulator.g += texture2D(CC_Texture0, clamp(v_texCoord + offsets[1].xy, texture_bounds.xy, texture_bounds.zw)).g;
        accumulator.b += texture2D(CC_Texture0, clamp(v_texCoord + offsets[2].xy, texture_bounds.xy, texture_bounds.zw)).b;
        
        offsets -= increments;
    }

	gl_FragColor = vec4(accumulator / float(sample_count), 1.0);

	//gl_FragColor = vec4(direction, 1.0, 1.0);
}
