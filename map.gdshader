shader_type canvas_item;

#define MAX_VISIBLE_TILES 2048

const ivec2 NEIGHBOUR_LOOKUP[] = {
	ivec2(0,-1),  ivec2(1,-1),  ivec2(1,0), ivec2( 0,1), ivec2(-1,0), ivec2(-1,-1),   // from % 2 (0, 0)  not horizontal
	ivec2(0,-1),  ivec2(1,-1),  ivec2(1,0), ivec2( 0,1), ivec2(-1,0), ivec2(-1,-1),   // from % 2 (0, 1)  not horizontal
	ivec2(0,-1),  ivec2(1, 0),  ivec2(1,1), ivec2( 0,1), ivec2(-1,1), ivec2(-1, 0),   // from % 2 (1, 0)  not horizontal
	ivec2(0,-1),  ivec2(1, 0),  ivec2(1,1), ivec2( 0,1), ivec2(-1,1), ivec2(-1, 0),   // from % 2 (1, 1)  not horizontal
	ivec2(0,-1),  ivec2(1, 0),  ivec2(0,1), ivec2(-1,1), ivec2(-1,0), ivec2(-1,-1),   // from % 2 (0, 0)      horizontal
	ivec2(1,-1),  ivec2(1, 0),  ivec2(1,1), ivec2( 0,1), ivec2(-1,0), ivec2( 0,-1),   // from % 2 (0, 1)      horizontal
	ivec2(0,-1),  ivec2(1, 0),  ivec2(0,1), ivec2(-1,1), ivec2(-1,0), ivec2(-1,-1),   // from % 2 (1, 0)      horizontal
	ivec2(1,-1),  ivec2(1, 0),  ivec2(1,1), ivec2( 0,1), ivec2(-1,0), ivec2( 0,-1)    // from % 2 (1, 1)      horizontal
};

struct GridConfig {
	vec2 tile_size;
	vec2 offset;
	bool is_horizontal;
};

uniform vec2 tile_size;
uniform vec2 offset;
uniform bool is_horizontal;

uniform ivec2 visible[MAX_VISIBLE_TILES];
uniform int visible_size = 0;

int mod2(int x) {
	return abs(x) % 2;  // Not sure how it handles negative integers
}

float lenght_sqr(vec2 v) {
	return dot(v, v);
}

vec2 eval_tile(ivec2 inp, GridConfig config) {
	vec2 inpf = vec2(inp);
	if (config.is_horizontal){
		return vec2(
			(mod2(inp.y) == 1 ? inpf.x + 0.5 : inpf.x) * config.tile_size.x + config.offset.x,
			inpf.y * .75 * config.tile_size.y + config.offset.y
		);
	} else {
		return vec2(
			inpf.x * .75 * config.tile_size.x + config.offset.x,
			(mod2(inp.x) == 1 ? inpf.y + 0.5 : inpf.y) * config.tile_size.y + config.offset.y
		);
	}
}

ivec2 get_neighbour(ivec2 inp, int neighbour_idx) {
	int index = neighbour_idx + mod2(inp.y)*6 + mod2(inp.x)*12 + int(is_horizontal)*24;
	return inp + NEIGHBOUR_LOOKUP[index];
}

ivec2 _get_tile_estimate(vec2 inp, GridConfig config) {
	vec2 del = (inp - config.offset) / config.tile_size;
	if (config.is_horizontal) del = del.yx;
	del.y += 0.5 * sign(del.y);
	del.x += 0.25 * sign(del.x);
	int x0 = int(del.x * 1.3333);
	ivec2 p0 = ivec2(x0, int(mod2(x0) == 0 ? del.y : del.y - 0.5));
	if (config.is_horizontal) p0 = p0.yx;
	return p0;
}

ivec2 get_tile(vec2 inp, GridConfig config) {
	ivec2 p0 = _get_tile_estimate(inp, config);
	float min_dist_sqr = lenght_sqr(eval_tile(p0, config) - inp);
	//for c in [p0 + Vector2i(0, 1), p0 + Vector2i(1, 0), p0 + Vector2i(1, 1)]:
	for (int i=0; i < 6; i++) {
		ivec2 c = get_neighbour(p0, i);
		float dist_sqr = lenght_sqr(eval_tile(c, config) - inp);
		if (dist_sqr < min_dist_sqr) {
			p0 = c;
			min_dist_sqr = dist_sqr;
		}
	}
	return p0;
}

void fragment() {
	GridConfig config;
	config.tile_size = tile_size;
	config.offset = offset;
	config.is_horizontal = is_horizontal;
	vec2 pixel = (UV - .5) / TEXTURE_PIXEL_SIZE;
	bool is_visible = false;
	ivec2 current_tile = get_tile(pixel, config);
	for (int i=0; i < visible_size; i++) {
		if (visible[i] == current_tile) {
			is_visible = true;
		}
	}
	
	if (is_visible){
		COLOR = texture(TEXTURE, UV);
	} else {
		COLOR = mix(texture(TEXTURE, UV), vec4(0,0,0,1), 1.0);
	}
	
	//COLOR.rg = fract(vec2(_get_tile_estimate(pixel, config)) / 3.0);
	//COLOR.rg = fract(vec2(get_tile(pixel, config)) / 3.0);
	
	//vec2 error = pixel - eval_tile(get_tile(pixel, config), config);
	//COLOR.rg = abs(error) * 0.01;
	
	/*ivec2 index = ivec2(6, -6);
	float error = 1.0;
	for (int i=0; i < 6; i++){
		ivec2 n = get_neighbour(index, i);
		error *= step(0.5, abs(length(eval_tile(n, config) - pixel)) * 0.1);
	}
	if (index == _get_tile_estimate(pixel, config)) {
		COLOR.rg = vec2(0);
	} else {
		COLOR.rg = vec2(error);
	}*/
}
