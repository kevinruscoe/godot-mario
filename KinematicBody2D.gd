extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = -180
export (int) var gravity = 300

var velocity = Vector2.ZERO

var is_jumping = false
var is_moving = false

export (float, 0, 1.0) var friction = 0.18
export (float, 0, 1.0) var acceleration = 0.25

signal has_become_stationary
signal has_started_moving
signal has_jumped
signal is_falling
signal is_rising
signal is_moving
signal has_landed

func _ready():
	connect("has_jumped", self, "_on_jump")
	connect("has_landed", self, "_on_landed")
	connect("has_become_stationary", self, "_on_has_become_stationary")
	connect("has_started_moving", self, "_on_has_started_moving")
	connect("is_falling", self, "_on_is_falling")
	connect("is_rising", self, "_on_is_rising")

func _physics_process(delta):	
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_pressed("ui_left"):
		direction.x = -1
		
	if direction.x != 0:
		if not is_moving:
			emit_signal("has_started_moving")
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
	else:
		if is_moving:
			emit_signal("has_become_stationary")
		velocity.x = lerp(velocity.x, 0, friction)
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("ui_jump"):
		if is_on_floor():
			emit_signal("has_jumped")
	
	if velocity.y < 0:
		emit_signal("is_falling")
	elif velocity.y > 0:
		emit_signal("is_rising")
		
	if not velocity.x == 0:
		emit_signal("is_moving")
			
	if is_jumping and velocity.y == 0:
		emit_signal("has_landed")

func _on_jump():
	is_jumping = true
	velocity.y = jump_speed
	
func _on_landed():
	is_jumping = false

func _on_has_become_stationary():
	is_moving = false

func _on_has_started_moving():
	is_moving = true

func _on_is_falling():
	pass
	
func _on_is_rising():
	pass
