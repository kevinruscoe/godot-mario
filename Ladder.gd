extends Area2D

var height = 0

onready var sprite: Sprite = $Sprite
onready var collisionshape2d: CollisionShape2D = $CollisionShape2D
onready var floor_collisionshape2d: CollisionShape2D = $Floor/CollisionShape2D
onready var floordetector_collisionshape2d: CollisionShape2D = $FloorDetector/CollisionShape2D

func _ready():
	var current = 1

	var new_sprite = sprite.duplicate()
	
	collisionshape2d.shape.extents.y = height * 9
	collisionshape2d.position.y = collisionshape2d.shape.extents.y - 9
	
	while current < height:
		var child = new_sprite.duplicate()
		child.position.y += 18 * current
		child.region_rect.position.y += 18
		sprite.add_child(child)
		
		current += 1

func disable_static_body():
	floor_collisionshape2d.set_deferred("disabled", true)
	
func enable_static_body():
	floor_collisionshape2d.set_deferred("disabled", false)

func _on_body_entered(body):
	disable_static_body()
	
	EventBus.emit_signal("player_entered_on_ladder", self)

func _on_body_exited(body):
	enable_static_body()
	
	EventBus.emit_signal("player_exited_on_ladder", self)

func _on_FloorDetector_body_exited(body):
	EventBus.emit_signal("player_exited_above_ladder", self)

func _on_FloorDetector_body_entered(body):
	EventBus.emit_signal("player_entered_above_ladder", self)
