shader_type canvas_item;

uniform float weight: hint_range(0.0,360);
uniform float border_px: hint_range(0.0, 10.0) = 4.0;
uniform float darken: hint_range(0.0, 1.0) = 0.95;
uniform float circle_radius = 0.5;

float dist_to_ray(vec2 p, vec2 dir) {
	if (dot(p, dir) <= 0.0) return length(p);     
	return abs(p.x * dir.y - p.y * dir.x);       
}

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	vec2 p = UV - vec2(0.5);

	// Angle depuis le haut, sens horaire (UV.y descend en Godot)
	float a = atan(p.x, -p.y);          // -PI..PI, 0 = haut
	float t = mod(a, TAU) / TAU;  
	float fill = weight / 360.0;

	float visible = step(t, fill);
	
	float d = circle_radius - length(p);
	if (fill < 1.0) {
		float end_a = fill * TAU;
		d = min(d, dist_to_ray(p, vec2(0.0, -1.0)));             // rayon de départ
		d = min(d, dist_to_ray(p, vec2(sin(end_a), -cos(end_a)))); // rayon de fin
	}

	float d_px = d / TEXTURE_PIXEL_SIZE.x;
	float border = 1.0 - smoothstep(border_px - 1.0, border_px, d_px);

	vec3 col = mix(COLOR.rgb, COLOR.rgb * darken, border);
	COLOR = vec4(col, tex.a * visible);
}
