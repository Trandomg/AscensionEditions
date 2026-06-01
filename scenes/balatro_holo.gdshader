shader_type canvas_item;

uniform float range = 1.0;

float hue(float s, float t, float h)
{
	float hs = mod(h, 1.)*6.;
	if (hs < 1.) return (t-s) * hs + s;
	if (hs < 3.) return t;
	if (hs < 4.) return (t-s) * (4.-hs) + s;
	return s;
}

vec4 RGB(vec4 c)
{
	if (c.y < 0.0001)
		return vec4(vec3(c.z), c.a);

	float t = (c.z < .5) ? c.y*c.z + c.z : -c.y*c.z + (c.y+c.z);
	float s = 2.0 * c.z - t;
	return vec4(hue(s,t,c.x + 1./3.), hue(s,t,c.x), hue(s,t,c.x - 1./3.), c.w);
}

vec4 HSL(vec4 c)
{
	float low = min(c.r, min(c.g, c.b));
	float high = max(c.r, max(c.g, c.b));
	float delta = high - low;
	float sum = high+low;

	vec4 hsl = vec4(.0, .0, .5 * sum, c.a);
	if (delta == .0)
		return hsl;

	hsl.y = (hsl.z < .5) ? delta / sum : delta / (2.0 - sum);

	if (high == c.r)
		hsl.x = (c.g - c.b) / delta;
	else if (high == c.g)
		hsl.x = (c.b - c.r) / delta + 2.0;
	else
		hsl.x = (c.r - c.g) / delta + 4.0;

	hsl.x = mod(hsl.x / 6., 1.);
	return hsl;
}

void fragment() {
	vec4 tex = texture(TEXTURE,VERTEX);

    vec4 hsl = HSL(0.5*tex + 0.5*vec4(0.,0.,1.,tex.a));

	float t = TIME*8.221;
	vec2 floored_uv = UV*5.0;// (floor((uv*texture_details.ba)))/texture_details.ba;
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 250.;

	vec2 field_part1 = uv_scaled_centered + 50.*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
	vec2 field_part2 = uv_scaled_centered + 50.*vec2(cos( t / 53.1532),  cos( t / 61.4532));
	vec2 field_part3 = uv_scaled_centered + 50.*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.+ (
        cos(length(field_part1) / 19.483) + sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92) ))/2.;

	float res = (.5 + .5* cos( (range) * 2.612 + ( field + -.5 ) *3.14));

	float low = min(tex.r, min(tex.g, tex.b));
    float high = max(tex.r, max(tex.g, tex.b));
	float delta = 0.2+0.3*(high- low) + 0.1*high;

	float gridsize = 0.79;
    float fac = 0.5*max(max(max(0., 7.*abs(cos(UV.x*gridsize*20.))-6.),max(0., 7.*cos(UV.y*gridsize*45. + UV.x*gridsize*20.)-6.)), max(0., 7.*cos(UV.y*gridsize*45. - UV.x*gridsize*20.)-6.));

	hsl.x = hsl.x + res + fac;
	hsl.y = hsl.y*1.3;
	hsl.z = hsl.z*0.6+0.4;

    tex =(1.-delta)*tex + delta*RGB(hsl)*vec4(0.9,0.8,1.2,tex.a);


	if (tex[3] < 0.7)
		tex[3] = tex[3]/3.;

	vec3 white_map = (1.0-vec3(smoothstep((0),length(COLOR.rgb),(0.6))))*2.0;
	vec3 shifting_color = vec3(clamp(fract(sin(exp(UV*3.0)+TIME)/2.0+0.5),0.2,1.0),0.5);
	float shifting_white = (-abs(sin(2.0*UV.x+UV.y+TIME))+1.0);

	COLOR.rgb = mix(COLOR.rgb,tex.rgb,(white_map*shifting_white)/2.0);
    COLOR += tex;
	//COLOR.rgb = shifting_color;
}



