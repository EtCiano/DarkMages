extends Timer
	
func _on_timeout() -> void:
	get_node("..").queue_free()
