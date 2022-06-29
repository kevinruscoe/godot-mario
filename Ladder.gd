extends Area2D

var height = 0

onready var sprite: Sprite = $Sprite
onready var collisionshape2d: CollisionShape2D = $CollisionShape2D
onready var staticbody2d_collisionshape2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready():
	var current = 0

	var new_sprite = sprite.duplicate()
	
	# extend the collision by the ladder height, and offsets the by -1/2 tile for walking collision
	collisionshape2d.shape.extents.y = (height + 1) * 9
	collisionshape2d.position.y = ((height + 1) / 2 * 18) - 12
	
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
		body._on_enter_ladder(self)

func _on_body_exited(body):
	if body.name == "Player":
		body._on_exit_ladder()
