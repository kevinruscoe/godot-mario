extends TileMap

var props = []

func _ready():
	_replace_props()
	
func _replace_props():
	var used_cells = get_used_cells()

	for used_cell in used_cells:
		
		var tile_name = tile_set.tile_get_name(
			get_cell(used_cell.x, used_cell.y)
		)
		
		if tile_name == "LadderTop":
			tile_name = "Ladder"
		
		var asset_name = "res://" + tile_name + ".tscn"
		
		if ResourceLoader.exists(asset_name):
			props.append({
				"tile_name": tile_name,
				"asset_name": asset_name,
				"spawn_position": used_cell * get_cell_size() + (get_cell_size() / 2),
				"cell_to_clear": used_cell
			})

	_replace_ladders();
	
	for prop in props:
		_replace_prop(prop)
		
func _get_ladder_tiles():
	var ladder_tiles = []
	
	for prop in props:
		if prop.tile_name == "Ladder":
			ladder_tiles.append(prop)
		if prop.tile_name == "LadderTop":
			ladder_tiles.append(prop)
	
	return ladder_tiles

func _replace_ladders():
	var ladders = []
	for ladder_tiles in _get_ladder_tiles():
		var ladder = _find_top_bottom_of_ladder(ladder_tiles)
		
		if ladder.top and ladder.bottom:
			var collected = false
			for found_ladder in ladders:
				var lower_tile_found = found_ladder.bottom.spawn_position == ladder.bottom.spawn_position
				var upper_tile_found = found_ladder.top.spawn_position == ladder.top.spawn_position
				if lower_tile_found and upper_tile_found:
					collected = true
					
			if not collected:
				ladders.append(ladder)
					
			
	for ladder in ladders:
		var prop_scene = load("res://Ladder.tscn")
		var prop_instance = prop_scene.instance()
		prop_instance.position = ladder.top.spawn_position
		prop_instance.height = ladder.bottom.cell_to_clear.y - ladder.top.cell_to_clear.y + 1

		add_child(prop_instance)

func _find_top_bottom_of_ladder(ladder):
	var top
	var bottom
	var current = ladder
	
	# need to clean the below for just the 1 loop?
	for i in range(1, 10):
		var adjectent_tiles = _get_adjectent_tiles(current)
		
		if not adjectent_tiles.above:
			break
			
		var above_tile_name = adjectent_tiles.above.tile_name
			
		if above_tile_name == "Ladder" or above_tile_name == "LadderTop":
			current = adjectent_tiles.above
			top = current
			
	for i in range(1, 10):
		var adjectent_tiles = _get_adjectent_tiles(current)
		
		if not adjectent_tiles.below:
			break
			
		var below_tile_name = adjectent_tiles.below.tile_name
			
		if below_tile_name == "Ladder" or below_tile_name == "LadderTop":
			current = adjectent_tiles.below
			bottom = current
	
	return {
		"top": top,
		"bottom": bottom
	}
		
func _get_prop_at(vector):
	var found
	
	for prop in props:
		if vector == prop.cell_to_clear:
			found = prop
			break
	
	return found
	
func _get_adjectent_tiles(tile):
	var tile_above = tile.cell_to_clear + Vector2.UP
	var tile_below = tile.cell_to_clear + Vector2.DOWN
	
	return {
		"above": _get_prop_at(tile_above),
		"below": _get_prop_at(tile_below),
	}

func _replace_prop(prop):
	var is_ladder = false
	
	if prop.tile_name == "Ladder":
		is_ladder = true
		
	if prop.tile_name == "LadderTop":
		is_ladder = true
		
	if not is_ladder:
		var prop_scene = load(prop.asset_name)
		var prop_instance = prop_scene.instance()
		prop_instance.position = prop.spawn_position

		add_child(prop_instance)

	set_cell(prop.cell_to_clear.x, prop.cell_to_clear.y, -1)
