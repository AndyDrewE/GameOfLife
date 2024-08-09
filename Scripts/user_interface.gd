##user_interface.gd

extends Control

@onready var step_slider = $step_time_slider
@onready var step_label = $step_time_slider/step_time_slider_label

func _ready():
	update_step_time_label()

func _process(delta):
	pass

func update_step_time_label():
	if step_label.text != str(step_slider.value):
		step_label.text = str(step_slider.value)


func _on_step_time_slider_value_changed(value):
	update_step_time_label()
