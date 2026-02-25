extends Node2D

# --- References ---
@onready var sprite = $EmptyCupSprite      # The visible cup Sprite2D
@onready var hitbox = $Hitbox              # The Area2D hitbox child

# --- Dragging ---
var is_dragging = false
var mouse_offset = Vector2.ZERO

# --- Textures ---
var cup_boba = preload("res://art/cup-boba.png")

func _ready():
	hitbox.connect("clicked", Callable(self, "_on_cup_hitbox_clicked"))


func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() - mouse_offset


# Called when player clicks the cup hitbox
func _on_cup_hitbox_clicked() -> void:
	if ToolManager.current_tool == ToolManager.Tool.NONE:
		# No scoop → start dragging
		is_dragging = true
		mouse_offset = get_global_mouse_position() - global_position
		
	elif ToolManager.current_tool == ToolManager.Tool.SCOOP:
		# Scoop active → change cursor & cup sprite, no dragging
		ToolManager.scoop_press()
		sprite.texture = cup_boba


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		# Stop dragging if dragging
		if is_dragging:
			is_dragging = false

		# Always release scoop cursor if scoop tool is active
		if ToolManager.current_tool == ToolManager.Tool.SCOOP:
			ToolManager.scoop_release()
