extends BaseState

export (NodePath) var idle_node
export (NodePath) var jump_node
export (NodePath) var on_ladder_node

onready var idle_state: BaseState = get_node(idle_node)
onready var jump_state: BaseState = get_node(jump_node)
onready var on_ladder_state: BaseState = get_node(on_ladder_node)

func enter() -> void:
	player.animated_sprite.play("walking")
	
func physics_process(delta: float) -> BaseState:
	if Input.is_action_pressed("ui_jump"):
		return jump_state
		
	if player.on_ladder and Input.is_action_pressed("ui_up"):
		return on_ladder_state
		
	if player.on_ladder and Input.is_action_pressed("ui_down"):
		return on_ladder_state
		
	if player.above_ladder and Input.is_action_pressed("ui_down"):
		return on_ladder_state
		
	var move = player.get_movement_input()
	
	if move == 0 and player.is_on_floor():
		return idle_state
	if move < 0:
		player.animated_sprite.flip_h = false
	elif move > 0:
		player.animated_sprite.flip_h = true
		
	player.velocity.x = lerp(player.velocity.x, move * player.move_speed, player.acceleration)
	player.velocity.y += player.get_gravity() * delta
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	return null
