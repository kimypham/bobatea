extends Node2D

@onready var sprite = $EmptyCupSprite
@onready var hitbox = $Hitbox

var is_dragging = false
var mouse_offset = Vector2.ZERO

var scoop_rotate = preload("res://art/scoop-rotate.png")
var scoop_empty = preload("res://art/scoop-empty.png")
var cup_boba = preload("res://art/cup-boba.png")

func _ready():
	print(get_children())  # prints all direct children
	print($Hitbox)         # should not be null
	hitbox.connect("clicked", Callable(self, "_on_cup_hitbox_clicked"))

func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() - mouse_offset
	

func _on_hitbox_clicked() -> void:
	if ToolManager.current_tool != ToolManager.Tool.SCOOP:
		return
	
	# Change cursor to scoop rotate
	ToolManager.scoop_press()
	
	# Change cup sprite
	$Sprite2D.texture = cup_boba
	
	# Start dragging if you want
	is_dragging = true
	mouse_offset = get_global_mouse_position() - global_position
