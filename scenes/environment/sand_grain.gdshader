shader_type spatial;

uniform vec4 color: source_color = vec4(255,255,0,255);
void fragment() {
	ALBEDO = color.rgb;
}
