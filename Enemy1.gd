extends KinematicBody2D


export (int) var speed = 45
export (int) var gravity = 300
export (int) var max_left = 100
export (int) var max_right = 10

var velocity: Vector2
var initial_position: Vector2

var walking_right = false

onready var animated_sprite = $AnimatedSprite

func _ready():
	initial_position = global_position

func _physics_process(delta):
	
	animated_sprite.flip_h = walking_right
	
	if walking_right:
		velocity.x = Vector2.RIGHT.x * speed
		
		if position.x > initial_position.x + max_right:
			walking_right = false
	else:
		velocity.x = Vector2.LEFT.x * speed
		
		if position.x < initial_position.x - max_left:
			walking_right = true
		
	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
func _on_Area2D_body_entered(body):
	pass
	if body is Player and body.is_falling:
		queue_free()
