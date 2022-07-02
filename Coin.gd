extends Area2D
	
func _on_body_entered(body):
	EventBus.emit_signal("player_collected_coins", 1)
	queue_free()
