extends Node

enum Tool {
	NONE,
	SCOOP
}

var current_tool : Tool = Tool.NONE

var scoop_idle = preload("res://art/scoop-boba.png")
var scoop_rotate = preload("res://art/scoop-rotate.png")
var scoop_empty = preload("res://art/scoop-empty.png")

var hotspot = Vector2(50, 20)

# Temporary flag: are we currently clicking the cup?
var pressing_cup := false

func toggle_scoop():
	if current_tool == Tool.SCOOP:
		reset_cursor()
	else:
		scoop()

func reset_cursor():
	current_tool = Tool.NONE
	Input.set_custom_mouse_cursor(null)

func scoop():
	current_tool = Tool.SCOOP
	Input.set_custom_mouse_cursor(scoop_idle, Input.CURSOR_ARROW, hotspot)
	pressing_cup = false  # reset

func scoop_press():
	if current_tool == Tool.SCOOP:
		Input.set_custom_mouse_cursor(scoop_rotate, Input.CURSOR_ARROW, hotspot)
		pressing_cup = true


func scoop_release():
	if current_tool == Tool.SCOOP and pressing_cup:
		Input.set_custom_mouse_cursor(scoop_empty, Input.CURSOR_ARROW, hotspot)
		pressing_cup = false
