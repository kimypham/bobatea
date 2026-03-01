extends Node

enum Tool {
	NONE,
	SCOOP,
	SCOOP_BOBA
}

var current_tool : Tool = Tool.NONE

var scoop_with_boba = preload("res://art/scoop-boba.png")
var scoop_rotate = preload("res://art/scoop-rotate.png")
var scoop_empty = preload("res://art/scoop-empty.png")

var hotspot = Vector2(50, 20)

# Temporary flag: are we currently clicking the cup?
var pressing_cup := false

func get_current_scoop() -> Tool:
	return current_tool

func toggle_scoop():
	if current_tool == Tool.SCOOP || current_tool == Tool.SCOOP_BOBA:
		reset_cursor()
	else:
		scoop_boba()

func reset_cursor():
	current_tool = Tool.NONE
	Input.set_custom_mouse_cursor(null)

func scoop_boba():
	current_tool = Tool.SCOOP_BOBA
	Input.set_custom_mouse_cursor(scoop_with_boba, Input.CURSOR_ARROW, hotspot)
	pressing_cup = false  # reset

func scoop_press():
	if current_tool == Tool.SCOOP || current_tool == Tool.SCOOP_BOBA:
		Input.set_custom_mouse_cursor(scoop_rotate, Input.CURSOR_ARROW, hotspot)
		pressing_cup = true


func scoop_release():
	if (current_tool == Tool.SCOOP || current_tool == Tool.SCOOP_BOBA) and pressing_cup:
		Input.set_custom_mouse_cursor(scoop_empty, Input.CURSOR_ARROW, hotspot)
		pressing_cup = false
		if current_tool == Tool.SCOOP_BOBA:
			current_tool = Tool.SCOOP  # boba has been deposited, now it's empty
