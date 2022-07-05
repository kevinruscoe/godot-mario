extends KinematicBody2D

class_name Player

onready var states = $state_manager
onready var animated_sprite = $AnimatedSprite

var initial_position: Vector2

var velocity: Vector2

# movement
export var move_speed: int = 100
export var climb_speed: int = 100
export (float, 0, 1.0) var friction: float = 0.18
export (float, 0, 1.0) var acceleration: float  = 0.25

# jump
export var jump_height : float = 32
export var jump_time_to_peak : float = 0.5
export var jump_time_to_descent : float = 0.25

onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var on_ladder
var above_ladder

func _ready() -> void:
	initial_position = global_position
	
	EventBus.connect("player_out_of_bounds", self, "_on_out_of_bounds")
	
	EventBus.connect("player_entered_on_ladder", self, "_on_player_entered_on_ladder")
	EventBus.connect("player_exited_on_ladder", self, "_on_player_exited_on_ladder")
	
	EventBus.connect("player_entered_above_ladder", self, "_on_player_entered_above_ladder")
	EventBus.connect("player_exited_above_ladder", self, "_on_player_exited_above_ladder")
	
	states.init(self)

func _unhandled_input(event: InputEvent) -> void:
	states.input(event)

func _physics_process(delta: float) -> void:
	states.physics_process(delta)

	if position.y > 180:
		EventBus.emit_signal("player_out_of_bounds")

func _process(delta: float) -> void:
	states.process(delta)

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func get_movement_input() -> int:
	if Input.is_action_pressed("ui_left"):
		return -1
	elif Input.is_action_pressed("ui_right"):
		return 1

	return 0

func _on_out_of_bounds():
	position = initial_position

func _on_player_entered_on_ladder(ladder):
	on_ladder = ladder

func _on_player_exited_on_ladder(ladder):
	on_ladder = null

func _on_player_entered_above_ladder(ladder):
	above_ladder = ladder

func _on_player_exited_above_ladder(ladder):
	above_ladder = null

