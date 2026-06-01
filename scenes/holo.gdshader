shader_type canvas_item;

void fragment() {
	// Sets the color to white if the pixel is more than the first argument
	// Like rounding with the bound specified. Can use to make a light map?

	/*
	float left = step(0.4,COLOR.g);
	float right = step(0.2,COLOR.b);
	float middle = step(0.1,COLOR.r);
	COLOR.rgb = vec3(middle*right*left);
	*/

	// First parameter, determines up to which remainder turns black
	// It creates '10' segments, and divides them into '10'/'5' sections
	// of which, have '5' subsections, of which the first '1' gets turned black

	/*
	float left = step(1,abs(float(int(floor(UV.x*10.0))%5)));
	COLOR.rbg = vec3(left);
	*/

	// Cross pattern
	// Colors according to UV map?
	/*
	float vertical = 1.0-step(1,abs(float(int(floor(UV.x*80.0+0.5))%20)))*0.5;
	float positive_line = 1.0-step(1,abs(float(int(floor(UV.x*40.0+1.0 + UV.y*80.0))%20)))*0.5;
	float negative_line = 1.0-step(1,abs(float(int(floor(UV.x*40.0 - UV.y*80.0))%20)))*0.5;
	//COLOR.rgb = vec3(UV,0.5);
	float r = 1.0-distance(vertical*positive_line*negative_line,0.5);
	COLOR.r = r*sin(TIME)/2.0+0.5*(UV.x/UV.y);

	float vertical2 = 1.0-step(2,abs(float(int(floor(UV.x*80.0+1.0))%20)))*0.5;
	float positive_line2 = 1.0-step(2,abs(float(int(floor(UV.x*40.0+1.5 + UV.y*80.0))%20)))*0.5;
	float negative_line2 = 1.0-step(2,abs(float(int(floor(UV.x*40.0+0.5 - UV.y*80.0))%20)))*0.5;
	COLOR.g = 1.0-distance(vertical2*positive_line2*negative_line2,0.5);

	float vertical3 = 1.0-step(3,abs(float(int(floor(UV.x*80.0+1.5))%20)))*0.5;
	float positive_line3 = 1.0-step(3,abs(float(int(floor(UV.x*40.0+2.0 + UV.y*80.0))%20)))*0.5;
	float negative_line3 = 1.0-step(3,abs(float(int(floor(UV.x*40.0+1.0 - UV.y*80.0))%20)))*0.5;
	COLOR.b = 1.0-distance(vertical3*positive_line3*negative_line3,0.5);
	COLOR.a = 0.25;
	*/
	//COLOR.rbg = 1.0-vec3(0.5,0.5,0.5)*vec3(0.5,0.5,0.5);

	// Compression?
	/*
	COLOR.r = floor(COLOR.r*(sin(TIME/10.0)/2.0+0.5)*30.0)/(sin(TIME/10.0)/2.0+0.5)/30.0;
	COLOR.g = floor(COLOR.g*(sin(TIME/10.0)/2.0+0.5)*20.0)/(sin(TIME/10.0)/2.0+0.5)/20.0;
	COLOR.b = floor(COLOR.b*(sin(TIME/10.0)/2.0+0.5)*10.0)/(sin(TIME/10.0)/2.0+0.5)/10.0;
	COLOR.a = 0.55;
	*/
	//Pulsating line?
	//COLOR.r += ((1.0-step(4,abs(float(int(floor(UV.x*80.0+2.0))%20)))*0.5) + fract(sin((UV.x)*(UV.y))*TIME))/5.0;
	//COLOR.rg = fract(UV);
	//COLOR.a = 0.25;


	//COLOR.a = fract(sin(exp(UV.x)+exp(UV.y)+UV.x+UV.y)*TIME/3.0);
	// Closest? attempt
	/*
	COLOR.a = floor(length(COLOR.rgb))/2.0;
	COLOR.r *= distance(1.0-step(1,abs(float(int(floor(UV.x*80.0+0.5))%20)))+0.5,fract(sin(exp(UV.x*3.0)+exp(UV.y))*TIME));
	COLOR.g *= distance(1.0-step(1,abs(float(int(floor(UV.x*80.0+0.5))%20)))+0.5,fract(sin(exp(UV.x)+exp(UV.y))*(TIME+20.0)));
	COLOR.b *= distance(1.0-step(1,abs(float(int(floor(UV.x*80.0+0.5))%20)))+0.5,fract(sin(exp(UV.x*5.0)+exp(UV.y))*(TIME+66.0)));
	*/



	// What ever the hell this is
	/*
	float a = fract(sin(dot(UV,vec2(10,10))*(TIME))) * fract(sin(dot(UV,vec2(-10,10))*((TIME))));
	float b = fract(sin(dot(UV,vec2(10,10))*(TIME))) * fract(sin(dot(UV,vec2(-10,10))*((TIME+20.0))));
	float c = fract(sin(dot(UV,vec2(10,10))*(TIME))) * fract(sin(dot(UV,vec2(-10,10))*((TIME+36.0))));
	COLOR.rgb += vec3(a,b,c);
	*/
	/*
	COLOR.rg = smoothstep(UV,fract(sin((UV)*TIME)),vec2(0.5,0.5));
	COLOR.a = 0.25;
	*/
	//COLOR.a = length(COLOR.rgb)/10.0;
	//COLOR.a *= -abs(sin(2.0*UV.x+2.0*TIME))+1.0;

	vec3 white_map = clamp(vec3(step(0.8,length(COLOR.rgb))),0,1);
	white_map = (1.0-vec3(smoothstep((0),length(COLOR.rgb),(0.6))))*2.0;
	vec3 shifting_color = vec3(fract(sin(exp(UV)+TIME)/2.0+0.5),0.5);
	float shifting_white = (-abs(sin(2.0*UV.x+UV.y+TIME))+1.0);
	//COLOR.rgb += (-abs(sin(2.0*UV.x+UV.y+TIME))+1.0)*white_map*shifting_color;
	//COLOR.rgb += vec3((-abs(sin(2.0*UV.x+UV.y+TIME))+1.0));
	//COLOR.rgb += mix(vec3((-abs(sin(2.0*UV.x+UV.y+TIME))+1.0))*white_map,shifting_color,0.5);
	//COLOR.rgb += mix(vec3((-abs(sin(2.0*UV.x+UV.y+TIME))+1.0)),white_map,shifting_color);
	COLOR.rgb = mix(COLOR.rgb,shifting_color,shifting_white*(white_map));
	//COLOR.rgb = white_map;

	
	// Try to make a blotchy white?
	

	
}
