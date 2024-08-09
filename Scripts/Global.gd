##Global.gd

extends Node2D

var MAX_STEP_TIME = 1.5
var STEP_TIME = 0.5
var ABLE_TO_PLACE = true
var playing = false


func toggle_play():
	playing = !playing
