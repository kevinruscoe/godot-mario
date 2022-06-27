extends Area2D
	
func _on_body_entered(body):
	EventBus.emit_signal("coin_collected")
	queue_free()
