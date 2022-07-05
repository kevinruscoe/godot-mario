extends BaseState

export (NodePath) var walk_node
export (NodePath) var idle_node

onready var walk_state: BaseState = get_node(walk_node)
onready var idle_state: BaseState = get_node(idle_node)

var exited_ladder: bool = false

func enter() -> void:
	player.animated_sprite.play("idle")
	exited_ladder = false
	
	if player.above_ladder:
		player.above_ladder.disable_static_body()
	
	EventBus.connect("player_exited_on_ladder", self, "_on_player_exited_on_ladder")
	
func exit() -> void:
	exited_ladder = true
	player.above_ladder = null
	player.on_ladder = null
	
func physics_process(delta: float) -> BaseState:
	if exited_ladder:
		return idle_state

	player.velocity.y = get_climbing_input() * player.climb_speed
	player.velocity.x = lerp(player.velocity.x, player.get_movement_input() * player.move_speed, player.acceleration)
	
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	return null

func _on_player_exited_on_ladder(ladder):
	exited_ladder = true
	
func get_climbing_input() -> int:
	if Input.is_action_pressed("ui_up"):
		return -1
	elif Input.is_action_pressed("ui_down"):
		return 1
	
	return 0
