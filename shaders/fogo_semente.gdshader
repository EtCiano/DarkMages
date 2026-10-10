shader_type canvas_item;
uniform sampler2D texturaRuido : hint_default_white;
uniform float angulo: hint_range(0.0, 360.0, 15.0);
uniform bool ativarRuido = true;
uniform bool animar = true;
uniform float suavidade : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float velocidadeAndar : hint_range(0.0, 5.0, 0.01) = 0.1;
uniform vec4 corRuido : source_color = vec4(0.6, 0.5, 1.0, 1.0);
uniform vec4 corMain : source_color = vec4(0.5, 0.4, 0.9, 1.0);
uniform float limite : hint_range(0.0, 1.0, 0.01);

void fragment() {
    vec4 corOriginal = texture(TEXTURE, UV);
	// Semente por partícula via COLOR (color_initial_ramp do emissor).
	// O ruído da partícula tem frequência maior (ver cena), então cada
	// janela tem várias manchas: o deslocamento muda o desenho sem cair
	// em pico/vale — sem anel, sem disco chapado.
	float semente = fract(COLOR.r * 7.13 + COLOR.g * 3.71 + COLOR.b * 5.37);
	vec2 deslocamento = vec2(semente, fract(semente * 7.7));
	float limiteParticula = limite * (0.9 + 0.2 * semente);
	vec2 uvAnimada;

	if (animar) {
		uvAnimada = fract(UV + vec2((TIME * velocidadeAndar)*cos(radians(angulo)), (TIME * velocidadeAndar) * sin(radians(angulo))) + deslocamento);
	} else {
		uvAnimada = fract(UV + vec2(velocidadeAndar, velocidadeAndar * 0.5) + deslocamento);
	}

    float ruido = texture(texturaRuido, uvAnimada).r;

	// responsável pela borda wobble
	if (corOriginal.a < ruido * limiteParticula) {
        corOriginal = vec4(corOriginal.rgb, 0.0);
    } else {
        corOriginal = vec4(corOriginal.rgb, 1.0);
    }

	// responsavel pela corRuido
	if (ativarRuido) {
    float transicao = smoothstep(limiteParticula - suavidade, limiteParticula + suavidade, ruido);
    COLOR = vec4(mix(corRuido.rgb, corMain.rgb, transicao), corOriginal.a);
}
}
