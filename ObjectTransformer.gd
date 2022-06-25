extends Node2D

onready var level: TileMap = $Level

func _ready():
	_replace_placeholder()
	
func _replace_placeholder():
	var used_cells = level.get_used_cells()

	for used_cell in used_cells:
		print(
			level.tile_set.tile_get_name(
				level.get_cell(used_cell.x, used_cell.y)
			)
		)
