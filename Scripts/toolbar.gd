##toolbar.gd

extends HBoxContainer

@onready var step_time_slider = $step_time_slider
@onready var step_time_label = $step_time_slider/step_time_label
@onready var tiles = get_tree().get_root().get_node("main/tiles")

func _ready():
	step_time_slider.max_value = Global.MAX_STEP_TIME
	step_time_slider.value = Global.STEP_TIME
	update_step_time_label()

func update_step_time_label():
	if step_time_label.text != str(step_time_slider.value*100):
		step_time_label.text = str(step_time_slider.value*100)

func _on_step_time_slider_value_changed(value):
	Global.STEP_TIME = value
	update_step_time_label()


func _on_toolbar_background_mouse_entered():
	Global.ABLE_TO_PLACE = false

func _on_toolbar_background_mouse_exited():
	Global.ABLE_TO_PLACE = true


func _on_play_pause_toggled(_toggled_on):
	Global.toggle_play()


func _on_button_pressed():
	tiles.clear_tiles()
