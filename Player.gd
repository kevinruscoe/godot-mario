extends KinematicBody2D

class_name Player

export (int) var move_speed = 120
export (int) var climb_speed = 120
export (float, 0, 1.0) var friction = 0.18
export (float, 0, 1.0) var acceleration = 0.25

export var jump_height : float = 32
export var jump_time_to_peak : float = 0.5
export var jump_time_to_descent : float = 0.25

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var velocity: Vector2 = Vector2.ZERO
var initial_positon: Vector2 = Vector2.ZERO

var is_jumping: bool = false
var is_moving: bool = false
var is_falling: bool = false
var is_rising: bool = false
var on_ladder: bool = false

var moved_on_ladder: bool = false
var walked_over_ladder: bool = false

var current_ladder

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
	
	EventBus.connect("player_entered_ladder", self, "_on_entered_ladder")
	EventBus.connect("player_exited_ladder", self, "_on_exited_ladder")
	
	EventBus.connect("player_has_jumped", self, "_on_jumped")
	EventBus.connect("player_has_landed", self, "_on_landed")
	EventBus.connect("player_has_become_stationary", self, "_on_has_become_stationary")
	EventBus.connect("player_has_started_moving", self, "_on_has_started_moving")

func _physics_process(delta):
	
	# Walk
	if not get_input_velocity() == 0:
		if not is_moving:
			EventBus.emit_signal("player_has_started_moving")
		velocity.x = lerp(velocity.x, get_input_velocity() * move_speed, acceleration)
	else:
		if is_moving:
			EventBus.emit_signal("player_has_become_stationary")
		velocity.x = lerp(velocity.x, 0, friction)
		
	# Climb and jump
	if on_ladder:
		if moved_on_ladder:
			velocity.y = 0
		else:
			if not walked_over_ladder:
				velocity.y += get_gravity() * delta
			
		if Input.is_action_pressed("ui_up"):
			moved_on_ladder = true
			current_ladder.disable_static_body()
			velocity.y = -climb_speed
			
		if Input.is_action_pressed("ui_down"):
			moved_on_ladder = true
			current_ladder.disable_static_body()
			velocity.y = climb_speed
	else:
		velocity.y += get_gravity() * delta
		
	# Move
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		EventBus.emit_signal("player_has_jumped")
		
	if is_moving:
		EventBus.emit_signal("player_is_moving")
			
	if is_jumping and velocity.y == 0:
		EventBus.emit_signal("player_has_landed")
		
	if position.y > 180:
		EventBus.emit_signal("player_out_of_bounds")
		position = initial_positon
		
	if velocity.y > 0:
		is_falling = true
		is_rising = true
	else:
		is_falling = false
		is_rising = false
		
func get_gravity():
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func get_input_velocity():
	var horizontal := 0.0
	
	if Input.is_action_pressed("ui_left"):
		horizontal -= 1.0
	if Input.is_action_pressed("ui_right"):
		horizontal += 1.0
	
	return horizontal

func _on_jumped():
	is_jumping = true
	velocity.y = jump_velocity
	
func _on_landed():
	is_jumping = false

func _on_has_become_stationary():
	is_moving = false

func _on_has_started_moving():
	is_moving = true
	
func _on_entered_ladder(ladder):
	current_ladder = ladder
	on_ladder = true

func _on_exited_ladder(ladder):
	ladder.enable_static_body()
	
	current_ladder = null
	on_ladder = false
	moved_on_ladder = false
