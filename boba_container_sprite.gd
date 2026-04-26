extends Sprite2D

var tool_action: String = ""  # set by parent, no longer @export

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if get_rect().has_point(to_local(get_global_mouse_position())):
			if tool_action != "" and ToolManager.has_method(tool_action):
				ToolManager.call(tool_action)
