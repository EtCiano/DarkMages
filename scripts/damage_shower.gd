extends Label

func _ready() -> void:
	$AnimationPlayer.play("default")
	
func _on_timeout() -> void:
	queue_free()
