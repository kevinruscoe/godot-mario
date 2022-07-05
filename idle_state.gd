extends BaseState

export (NodePath) var walk_node
export (NodePath) var jump_node

onready var walk_state: BaseState = get_node(walk_node)
onready var jump_state: BaseState = get_node(jump_node)

func enter() -> void:
	.enter()
	
	player.animated_sprite.play("idle")

func physics_process(delta: float) -> BaseState:
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		return walk_state
	
	if Input.is_action_pressed("ui_jump") and player.is_on_floor():
		return jump_state
		
	player.velocity.y += player.get_gravity() * delta
	player.velocity.x = lerp(player.velocity.x, 0, player.friction)
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	return null
