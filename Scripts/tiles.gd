##tiles.gd

extends TileMap

const TILE_SIZE = 16

@onready var step_timer = $step_timer


@export var width : int
@export var height : int

var temp_field
var is_dragging_mouse = false
var last_mouse_pos


func _ready():
	clear_tiles()
	

func _process(_delta):
	if step_timer.wait_time != Global.STEP_TIME:
		step_timer.wait_time = Global.STEP_TIME

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and Global.ABLE_TO_PLACE:
				is_dragging_mouse = true
				place_tile()
			else:
				is_dragging_mouse = false
	elif event is InputEventMouseMotion:
		var current_mouse_pos = (event.position/TILE_SIZE).floor()
		if is_dragging_mouse and current_mouse_pos != last_mouse_pos:
			place_tile()
			last_mouse_pos = current_mouse_pos
			
			
	if Input.is_action_just_pressed("ui_select"):
		Global.toggle_play()


func place_tile():
	var mouse_pos = (get_local_mouse_position()/TILE_SIZE).floor()
	var clicked_cell_atlas = get_cell_atlas_coords(0, mouse_pos)
	clicked_cell_atlas.x = (clicked_cell_atlas.x + 1) % 2
	set_cell(0, mouse_pos, 2, clicked_cell_atlas)

func update_field():
	if !Global.playing:
		return
	
	#adjust state in temp_field
	for x in range(width):
		for y in range(height):
			var live_neighbors = 0
			for x_off in [-1, 0, 1]:
				for y_off in [-1, 0, 1]:
					if x_off != y_off or x_off != 0:
						if get_cell_atlas_coords(0, Vector2(posmod((x+x_off),width),posmod((y+y_off),height))).x == 1:
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
	

func clear_tiles():
	temp_field = []
	for x in range(width):
		var temp = []
		for y in range(height):
			set_cell(0, Vector2(x,y), 2, Vector2i(0,0))
			temp.append(0)
		temp_field.append(temp)


func _on_step_timer_timeout():
	update_field()

