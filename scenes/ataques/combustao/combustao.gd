class_name combustao
extends Node2D

@export var distancia: float = 100.0
@export var anguloMouse: float
var posMouse: Vector2

@onready var ataque: Ataque = $ataque

var cooldown: float:
	get:
		return ataque.cooldown

func conjurar(posicaoPersonagem: Vector2, mousePos: Vector2) -> void:
	posMouse = mousePos
	anguloMouse = ataque.angulo_ate(posicaoPersonagem, posMouse)
	global_position = ataque.ponto_a_distancia(posicaoPersonagem, anguloMouse, distancia)
	$hitbox.definir()
	ataque.aplicar_dano($hitbox)
	acender()

func acender() -> void:
	$visual.material.get_shader_parameter("texturaRuido").noise.seed = randi()
	$visual/AnimationPlayer.play("default")
