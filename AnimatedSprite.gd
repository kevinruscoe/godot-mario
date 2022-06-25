extends AnimatedSprite

var flipped = false
var is_jumping = false
var is_moving= false

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		flipped = true
	if Input.is_action_pressed("ui_left"):
		flipped = false
		
	flip_h = flipped

func _on_KinematicBody2D_has_become_stationary():
	is_moving = false
	
	if not is_jumping:
		play("idle")

func _on_KinematicBody2D_has_started_moving():
	is_moving = true
	
	if not is_jumping:
		play("walking")

func _on_KinematicBody2D_has_jumped():
	is_jumping = true
	play("jumping")

func _on_KinematicBody2D_has_landed():
	is_jumping = false
	if is_moving:
		play("walking")
	else:
		play("idle")
