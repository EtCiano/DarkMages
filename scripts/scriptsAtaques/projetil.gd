extends Area2D

@export var pontosCoords: Array[Vector2]
var speed = 750
var direction = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	for pontoCoord in pontosCoords:
		while global_position != pontoCoord:
			global_position += direction * speed * delta
			
