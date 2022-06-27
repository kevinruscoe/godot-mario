extends TileMap

func _ready():
	_replace_props()
	
func _replace_props():
	var used_cells = get_used_cells()

	for used_cell in used_cells:
		
		var tile_name = tile_set.tile_get_name(
			get_cell(used_cell.x, used_cell.y)
		)
		
		var asset_name = "res://" + tile_name + ".tscn"
		
		if ResourceLoader.exists(asset_name):
			
			var prop_scene = load(asset_name)
			var prop_instance = prop_scene.instance()
			prop_instance.position = used_cell * get_cell_size() + (get_cell_size() / 2)
			
			add_child(prop_instance)
			
			set_cell(used_cell.x, used_cell.y, -1)
