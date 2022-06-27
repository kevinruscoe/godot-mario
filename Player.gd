extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = -180
export (int) var gravity = 300

var velocity = Vector2.ZERO

var initial_positon: Vector2

var is_jumping = false
var is_moving = false
var is_falling = false
var is_rising = false
var on_ladder = false

var moved_on_ladder = false
var walked_over_ladder = false

var ladder_timer: Timer

export (float, 0, 1.0) var friction = 0.18
export (float, 0, 1.0) var acceleration = 0.25

signal has_become_stationary
signal has_started_moving
signal has_jumped
signal has_landed
signal is_moving
signal is_falling
signal is_rising

onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	initial_positon = global_position
	
	connect("has_jumped", self, "_on_jump")
	connect("has_landed", self, "_on_landed")
	connect("has_become_stationary", self, "_on_has_become_stationary")
	connect("has_started_moving", self, "_on_has_started_moving")
	
	ladder_timer = Timer.new()
	add_child(ladder_timer)
	ladder_timer.connect("timeout", self, "_on_ladder_timer_timeout")

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
		
	if on_ladder:
		if walked_over_ladder:
			velocity.y = 0
			
		if moved_on_ladder:
			velocity.y = 0
		else:
			if not walked_over_ladder:
				velocity.y += gravity * delta
			
		if Input.is_action_pressed("ui_up"):
			moved_on_ladder = true
			velocity.y = -speed
			
		if Input.is_action_pressed("ui_down"):
			moved_on_ladder = true
			velocity.y = speed
	else:
		velocity.y += gravity * delta
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("ui_jump"):
		if is_on_floor():
			emit_signal("has_jumped")
		
	if is_moving:
		emit_signal("is_moving")
			
	if is_jumping and velocity.y == 0:
		emit_signal("has_landed")
		
	if position.y > 180:
		EventBus.emit_signal("out_of_bounds")
		position = initial_positon
		
	if velocity.y > 0:
		is_falling = true
		is_rising = true
	else:
		is_falling = false
		is_rising = false

func _on_jump():
	is_jumping = true
	velocity.y = jump_speed
	
func _on_landed():
	is_jumping = false

func _on_has_become_stationary():
	is_moving = false

func _on_has_started_moving():
	is_moving = true
	
func _on_enter_ladder(from_top = false):
	on_ladder = true
	
	if from_top:
		walked_over_ladder = true
		
	
func _on_exit_ladder():
	on_ladder = false

	ladder_timer.set_wait_time(.1)
	ladder_timer.start()

func _on_ladder_timer_timeout():
	if not on_ladder:
		moved_on_ladder = false
