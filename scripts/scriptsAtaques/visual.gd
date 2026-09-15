extends Sprite2D

@export var textura: Texture2D
@export var shaderMaterial: Material = null
@export var posicao: Vector2 = Vector2(0.0, 0.0)
@export var tamanho: Vector2 = Vector2(1.0, 1.0)

func definir() -> void:
	texture = textura
	material = shaderMaterial
	position = posicao
	scale = tamanho
	
