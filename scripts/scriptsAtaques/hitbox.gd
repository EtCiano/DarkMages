extends CollisionShape2D

@export var forma: Shape2D

@export var tamanho: Vector2 # para retangulo
@export var raio: float 	 # para circulos e capsulas
@export var altura: float 	 # para capsulas

@export var posicao: Vector2

func definir() -> void:
	match forma:
		CircleShape2D:
			forma.radius = raio
		RectangleShape2D:
			forma.size = tamanho
		CapsuleShape2D:
			forma.radius = raio
			forma.height = altura
	
	position = posicao
