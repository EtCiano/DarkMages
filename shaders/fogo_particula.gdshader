shader_type canvas_item;

uniform sampler2D tela : hint_screen_texture, filter_linear;
uniform sampler2D texturaRuido : hint_default_white, filter_linear;

uniform bool ativarRuido = true;
uniform bool animar = true;
uniform float suavidade : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform float velocidadeAndar : hint_range(0.0, 5.0, 0.01) = 0.1;
uniform vec4 corRuido : source_color = vec4(0.6, 0.5, 1.0, 1.0);
uniform vec4 corMain : source_color = vec4(0.5, 0.4, 0.9, 1.0);
uniform float limite : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform vec2 direcaoFogo = vec2(1.0, 1.0);
uniform float escalaRuido = 0.004; // pixels -> UV do ruído (menor = ruído maior)

varying vec2 pos_local;

void vertex() {
    pos_local = VERTEX; // posição no espaço local do grupo, não da partícula
}

void fragment() {
    vec4 c = texture(tela, SCREEN_UV);

    vec2 uvRuido = pos_local * escalaRuido;
    if (animar) {
        uvRuido += vec2(TIME * velocidadeAndar) * direcaoFogo;
    }
    float ruido = texture(texturaRuido, fract(uvRuido)).r;

    float alpha = (c.a < ruido * limite) ? 0.0 : 1.0;

    if (ativarRuido) {
        float transicao = smoothstep(limite - suavidade, limite + suavidade, ruido);
        COLOR = vec4(mix(corRuido.rgb, corMain.rgb, transicao), alpha);
    } else {
        COLOR = vec4(c.rgb, alpha);
    }
}