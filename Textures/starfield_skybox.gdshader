shader_type sky;

uniform float star_height = 5.0;
uniform float star_blend : hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float depth_blend : hint_range(0.0, 1.0, 0.1) = 0.1;
uniform float star_size = 5;
uniform float flare_ratio : hint_range(0.0, 1.0, 0.1) = 0.1;

vec2 RandomVec2(vec2 seed) {
	seed = fract(seed * vec2(123.45, 784.29));
	seed += dot(seed, seed + 875.34);
	float x = fract(seed.x * 164.32);
	float y = fract(seed.y * 287.21);
	return vec2(x, y) - 0.5;
}

float Star(vec2 uv, float flare){
	float star = 0.01 / length(uv);
	float rays = max(0, 1.0 - abs(uv.x * uv.y) * 1000.0) * star;
	star += rays * flare;
	return pow(star, 3);
}

void sky() {
	COLOR += vec3(0.002, 0.0, 0.003);
	
	float blend = smoothstep(star_blend, 1, abs(EYEDIR.y));
	float depth_curve = pow(abs(EYEDIR.y), depth_blend);
	vec2 uv = EYEDIR.xz / depth_curve * star_height;
	vec2 grid_uv = fract(uv) - 0.5;
	vec2 grid_id = floor(uv);
	
	for(float y = -1.0; y <=1.0; y++){
		for(float x = -1.0; x <= 1.0; x++){
			vec2 offset = vec2(x,y);
			vec2 rv = RandomVec2(grid_id + offset);
			float size = (rv.x + 0.5) * star_size;
			float flare = smoothstep(star_size * (1.0 - flare_ratio), star_size, size);
			COLOR += Star(grid_uv - offset - rv, flare) * blend * size;
		}
	}
	
}
