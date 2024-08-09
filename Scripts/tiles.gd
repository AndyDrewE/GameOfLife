##tiles.gd

extends TileMap

const TILE_SIZE = 16


var step_time : int = 16

@export var width : int
@export var height : int

var playing = false
var able_to_place_tiles = true

var temp_field



func _ready():
	var width_px = width* TILE_SIZE
	var height_px = height * TILE_SIZE
	
	temp_field = []
	
	for x in range(width):
		var temp = []
		for y in range(height):
			set_cell(0, Vector2(x,y), 2, Vector2i(0,0))
			temp.append(0)
		temp_field.append(temp)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		playing = !playing
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and able_to_place_tiles:
			var mouse_pos = (get_local_mouse_position()/TILE_SIZE).floor()
			var clicked_cell_atlas = get_cell_atlas_coords(0, mouse_pos)
			clicked_cell_atlas.x = (clicked_cell_atlas.x + 1) % 2
			
			set_cell(0, mouse_pos, 2, clicked_cell_atlas)
		

func _process(delta):
	if Engine.get_process_frames() % step_time == 0:
		update_field()


func update_field():
	if !playing:
		return
	
	#adjust state in temp_field
	for x in range(width):
		for y in range(height):
			var live_neighbors = 0
			for x_off in [-1, 0, 1]:
				for y_off in [-1, 0, 1]:
					if x_off != y_off or x_off != 0:
						if get_cell_atlas_coords(0, Vector2(x+x_off,y+y_off)).x == 1:
							live_neighbors += 1
			
			if get_cell_atlas_coords(0, Vector2(x,y)).x == 1:
				if live_neighbors in [2,3]:
					temp_field[x][y] = 1
				else:
					temp_field[x][y] = 0
			else:
				if live_neighbors == 3:
					temp_field[x][y] = 1
				else:
					temp_field[x][y] = 0
					
	#update tileMap
	for x in range(width):
		for y in range(height):
			set_cell(0, Vector2(x,y), 2, Vector2(temp_field[x][y], 0))

func update_step_time(new_step_time : int):
	if step_time != new_step_time:
		step_time = new_step_time

