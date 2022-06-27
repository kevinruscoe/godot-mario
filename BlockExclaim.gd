extends StaticBody2D

var been_hit = false

onready var area2d: Area2D = $Area2D
onready var sprite: Sprite = $Sprite

func hit():
	been_hit = false
	area2d.queue_free()
	
	var sprite_region_rect = sprite.get_region_rect()
	sprite_region_rect.position.y = 18
	
	sprite.set_region_rect(sprite_region_rect)
	
func _on_body_entered(body):
	if body.name == "Player":
		hit()
		
