extends Area2D
	
func _on_body_entered(body):
	EventBus.emit_signal("coins_collected", 1)
	queue_free()
