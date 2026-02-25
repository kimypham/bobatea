extends Sprite2D

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_rect().has_point(to_local(get_global_mouse_position())):
			ToolManager.scoop()
