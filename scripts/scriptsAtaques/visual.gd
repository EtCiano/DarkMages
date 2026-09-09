extends Sprite2D

@export var textura: Texture2D
@export var shaderMaterial: Material
@export var posicao: Vector2
@export var tamanho: Vector2

func definir() -> void:
	texture = textura
	material = shaderMaterial
	position = posicao
	scale = tamanho
