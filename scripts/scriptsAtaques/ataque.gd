class_name Ataque
extends Area2D

@export var custoMana: float
@export var danoBase: float
@export var espacosUsados: int
@export var classeUsada: Global.classe
@export var cooldown: float
@export var conjurador: Global.entidade = Global.entidade.PLAYER

func aplicar_dano(hitbox: Area2D, dano: float = danoBase) -> void:
	hitbox.dano = dano
	hitbox.origem = conjurador

func angulo_ate(origem: Vector2, alvo: Vector2) -> float:
	return (alvo - origem).angle()

func ponto_a_distancia(origem: Vector2, angulo: float, distancia: float) -> Vector2:
	return origem + Vector2.RIGHT.rotated(angulo) * distancia
