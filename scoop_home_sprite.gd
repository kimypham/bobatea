extends Sprite2D

var scoop_empty_texture = preload("res://art/scoop-empty.png")
var hotspot = Vector2(50, 20)  # adjust to your scoop tip

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if get_rect().has_point(to_local(get_global_mouse_position())):
				if visible:
					# Hide the sprite
					visible = false
					
					# Set ToolManager to SCOOP
					ToolManager.current_tool = ToolManager.Tool.SCOOP
					
					# Set the cursor to scoop_empty
					Input.set_custom_mouse_cursor(scoop_empty_texture, Input.CURSOR_ARROW, hotspot)
					
					# Reset any “pressing cup” state
					ToolManager.pressing_cup = false
				else:
					ToolManager.reset_cursor()
					visible = true
