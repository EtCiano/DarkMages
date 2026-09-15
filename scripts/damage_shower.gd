extends Label

func _on_timeout() -> void:
	queue_free()
