extends Area2D

var height = 0

onready var sprite: Sprite = $Sprite
onready var collisionshape2d: CollisionShape2D = $CollisionShape2D
onready var staticbody2d_collisionshape2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready():
	var current = 0

	var new_sprite = sprite.duplicate()
	
	collisionshape2d.shape.extents.y = (height) * 9
	collisionshape2d.position.y = ((height) / 2 * 18)
	
	while current < height:
		var child = new_sprite.duplicate()
		child.position.y += (18 * (current + 1))
		child.region_rect.position.y += 18
		sprite.add_child(child)
		
		current += 1

func disable_static_body():
	staticbody2d_collisionshape2d.set_deferred("disabled", true)
	
func enable_static_body():
	staticbody2d_collisionshape2d.set_deferred("disabled", false)

func _on_body_entered(body):
	if body.name == "Player":
		EventBus.emit_signal("player_entered_ladder", self)

func _on_body_exited(body):
	if body.name == "Player":
		EventBus.emit_signal("player_exited_ladder", self)

func _on_TopArea2D_body_entered(body):
	if body.name == "Player":
		print(1)
		EventBus.emit_signal("player_entered_above_ladder", self)

func _on_TopArea2D_body_exited(body):
	if body.name == "Player":
		print(0)
		EventBus.emit_signal("player_exited_above_ladder", self)
