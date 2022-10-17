shader_type canvas_item;

// This shader will take in a gradient texture, then use the average rgb value
// to determine colour in the gradient.

uniform sampler2D gradient;
varying vec4 modulate;
void vertex(){
	modulate = COLOR;
}
void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float t = (tex.r + tex.g + tex.b) / 3.0;
	vec4 color = texture(gradient, vec2(t, UV.y));
	COLOR = color * modulate * tex.a;
	// Place fragment code here.
}
