#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

void main(void)
{
    vec2 resolution = vec2(1280.0, 720.0);
    vec2 uv = v_texCoord;

	float amount = 0.0;
	
	amount = (1.0 + sin(CC_Time.y*6.0)) * 0.5;
	amount *= 1.0 + sin(CC_Time.y*16.0) * 0.5;
	amount *= 1.0 + sin(CC_Time.y*19.0) * 0.5;
	amount *= 1.0 + sin(CC_Time.y*27.0) * 0.5;
	amount = pow(amount, 3.0);

	amount *= 0.05;
	
    vec3 col;
    col.r = texture2D(CC_Texture0, vec2(uv.x+amount,uv.y) ).r;
    col.g = texture2D(CC_Texture0, uv ).g;
    col.b = texture2D(CC_Texture0, vec2(uv.x-amount,uv.y) ).b;

	col *= (1.0 - amount * 0.5);
	
    gl_FragColor = vec4(col,1.0);
}
