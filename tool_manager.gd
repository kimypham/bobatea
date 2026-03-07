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

func _ready():
	get_tree().root.size_changed.connect(_on_window_resized)

func _on_window_resized():
	match current_tool:
		Tool.SCOOP_BOBA:
			set_scaled_cursor(scoop_with_boba, hotspot)
		Tool.SCOOP:
			set_scaled_cursor(scoop_rotate, hotspot)
			
func set_scaled_cursor(image: Texture2D, hotspot: Vector2 = Vector2.ZERO):
	var base_size = Vector2(1152, 648)
	var window_size = Vector2(DisplayServer.window_get_size())
	var uniform_scale = min(window_size.x / base_size.x, window_size.y / base_size.y)
	
	var cursor_scale = uniform_scale * 0.5
	
	var img = image.get_image()
	img.convert(Image.FORMAT_RGBA8)
	
	var new_w = max(1, roundi(img.get_width() * cursor_scale))
	var new_h = max(1, roundi(img.get_height() * cursor_scale))
	img.resize(new_w, new_h, Image.INTERPOLATE_NEAREST)
	
	var new_texture = ImageTexture.create_from_image(img)
	var scaled_hotspot = hotspot * cursor_scale
	Input.set_custom_mouse_cursor(new_texture, Input.CURSOR_ARROW, scaled_hotspot)
	
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
	set_scaled_cursor(scoop_with_boba, hotspot)
	pressing_cup = false  # reset

func scoop_press():
	if current_tool == Tool.SCOOP || current_tool == Tool.SCOOP_BOBA:
		set_scaled_cursor(scoop_rotate, hotspot)
		pressing_cup = true


func scoop_release():
	if (current_tool == Tool.SCOOP || current_tool == Tool.SCOOP_BOBA) and pressing_cup:
		set_scaled_cursor(scoop_empty, hotspot)
		pressing_cup = false
		reset_cursor()
		#if current_tool == Tool.SCOOP_BOBA:
			#current_tool = Tool.SCOOP  # boba has been deposited, now it's empty
