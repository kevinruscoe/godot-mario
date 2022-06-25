extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = -180
export (int) var gravity = 300

var velocity = Vector2.ZERO

var is_jumping = false

export (float, 0, 1.0) var friction = 0.18
export (float, 0, 1.0) var acceleration = 0.25

signal has_become_stationary
signal has_started_moving
signal has_jumped
signal is_falling
signal has_landed

func _physics_process(delta):
	
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed("ui_left"):
		dir -= 1
		
	if dir != 0:
		emit_signal("has_started_moving")
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		emit_signal("has_become_stationary")
		velocity.x = lerp(velocity.x, 0, friction)
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.y < 0:
		emit_signal("is_falling")
	
	if Input.is_action_just_pressed("ui_select"):
		if is_on_floor():
			is_jumping = true
			emit_signal("has_jumped")
			velocity.y = jump_speed
			
	if is_jumping and velocity.y == 0:
		emit_signal("has_landed")
		is_jumping = false
