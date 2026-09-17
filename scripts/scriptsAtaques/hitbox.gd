extends Area2D

@export var forma: Shape2D

@export var tamanho: Vector2 # para retangulo
@export var raio: float 	 # para circulos e capsulas
@export var altura: float 	 # para capsulas
@export var posicao: Vector2 = Vector2(0.0, 0.0)

@export var dano: float
@export var origem: Global.entidade

@export var cor_da_borda: Color = Color(1, 0, 0, 1)
@export var espessura: float = 2.0

func definir() -> void:
	$CollisionShape2D.shape = forma
	position = posicao
	

func _ready():
	if Global.debug:
		queue_redraw()

func _draw():
	var collision_node = $CollisionShape2D

	if collision_node and collision_node.shape is RectangleShape2D:
		var rect_shape = collision_node.shape as RectangleShape2D
		var tamanhoRect = rect_shape.extents

		var rect = Rect2(-tamanhoRect, tamanhoRect * 2)

		draw_rect(rect, cor_da_borda, false, espessura)
	
	if collision_node and collision_node.shape is CircleShape2D:
		var circle_shape = collision_node.shape as CircleShape2D
		var raio = circle_shape.radius
		draw_arc(Vector2.ZERO, raio, 0, TAU, 64, cor_da_borda, espessura)
