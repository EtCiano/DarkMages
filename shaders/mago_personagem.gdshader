shader_type canvas_item;

uniform vec4 corClasse = vec4(0.0, 1.0, 0.0, 1.0);

void fragment() {
	if (COLOR.r == 0.0 && COLOR.b == 0.0 && COLOR.g == 1.0) {
		COLOR = corClasse;
	}
}