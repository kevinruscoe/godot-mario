extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body._on_enter_ladder()

func _on_body_exited(body):
	if body.name == "Player":
		body._on_exit_ladder()
