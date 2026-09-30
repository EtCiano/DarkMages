shader_type canvas_item;

uniform sampler2D texturaRuido : hint_default_white;
uniform bool ativarRuido = true;
uniform bool animar = true;
uniform float suavidade : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float velocidadeAndar : hint_range(0.0, 5.0, 0.01) = 0.1;
uniform vec4 corRuido : source_color = vec4(0.6, 0.5, 1.0, 1.0);
uniform vec4 corMain : source_color = vec4(0.5, 0.4, 0.9, 1.0);
uniform float limite : hint_range(0.0, 1.0, 0.01);
uniform vec2 direcaoFogo = vec2(1.0, 1.0);

varying float particula_seed;

float hash1(float n) {
    return fract(sin(n * 43758.5453) * 43758.5453);
}

void vertex() {
    particula_seed = hash1(INSTANCE_CUSTOM.x);
}

void fragment() {
    vec4 corOriginal = texture(TEXTURE, UV);
    vec2 uvAnimada;

    if (animar) {
        uvAnimada = fract(UV + vec2(TIME * velocidadeAndar, TIME * velocidadeAndar) * direcaoFogo);
    } else {
        uvAnimada = fract(UV + vec2(velocidadeAndar, velocidadeAndar * 0.5));
    }

    vec2 uvRuido = uvAnimada + vec2(particula_seed, particula_seed * 0.3183098861837907);
    float ruido = texture(texturaRuido, uvRuido).r;

    if (corOriginal.a < ruido * limite) {
        corOriginal = vec4(corOriginal.rgb, 0.0);
    } else {
        corOriginal = vec4(corOriginal.rgb, 1.0);
    }

    if (ativarRuido) {
        float transicao = smoothstep(limite - suavidade, limite + suavidade, ruido);
        COLOR = vec4(mix(corRuido.rgb, corMain.rgb, transicao), corOriginal.a);
    }
}