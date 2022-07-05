extends BaseState

export (NodePath) var idle_node

onready var idle_state: BaseState = get_node(idle_node)

func enter() -> void:
	.enter()
	
	player.velocity.y = player.jump_velocity
	
	player.animated_sprite.play("jumping")

func physics_process(delta: float) -> BaseState:
	var move = player.get_movement_input()
	
	if move < 0:
		player.animated_sprite.flip_h = false
	elif move > 0:
		player.animated_sprite.flip_h = true
	
	player.velocity.x = lerp(player.velocity.x, player.get_movement_input() * player.move_speed, player.acceleration)
	player.velocity.y += player.get_gravity() * delta
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if player.is_on_floor():
		return idle_state

	return null
