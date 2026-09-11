extends CharacterBody2D

signal hit(hitbox: Area2D)

@export var forma: Shape2D

@export var tamanho: Vector2 # para retangulo
@export var raio: float 	 # para circulos e capsulas
@export var altura: float 	 # para capsulas

@export var dano: float

@export var origem: Global.entidade = Global.entidade.INIMIGO

func _ready() -> void:
	$hitbox.area_entered.connect(_on_hitbox_area_entered)

func definir() -> void:
	match forma:
		CircleShape2D:
			forma.radius = raio
		RectangleShape2D:
			forma.size = tamanho
		CapsuleShape2D:
			forma.radius = raio
			forma.height = altura
	
	$CollisionShape2D.shape = forma
	$hitbox/CollisionShape2D.shape = forma
	

func _on_hitbox_area_entered(hitBox: Area2D) -> void:
	hit.emit(hitBox)
