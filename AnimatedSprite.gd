extends AnimatedSprite

var flipped = false

func _ready():
	play("idle")

func _physics_process(delta):
	if Input.is_action_pressed("ui_right"):
		flipped = true
	if Input.is_action_pressed("ui_left"):
		flipped = false
		
	flip_h = flipped

func _on_Player_has_become_stationary():
	if not get_parent().is_moving and not get_parent().is_jumping:
		play("idle")

func _on_Player_has_started_moving():
	if get_parent().is_moving:
		play("walking")

func _on_Player_has_jumped():
	play("jumping")

func _on_Player_has_landed():
	if get_parent().is_moving:
		play("walking")
	else:
		play("idle")
