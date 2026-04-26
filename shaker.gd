extends Node2D

@onready var sprite = $ShakerSprite
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/ShakerHitbox

@export var shaker_size: String = "regular"

const hitbox_size_medium: Vector2 = Vector2(145, 360)
const hitbox_position_medium: Vector2 = Vector2(0, -50)

const hitbox_size_large: Vector2 = Vector2(145, 370)
const hitbox_psotion_large: Vector2 = Vector2(0, -25)
const shaker_large_texture = preload("res://art/shaker-large.png")

const shaker_small_ice_small = preload("res://art/shaker-small-ice-small.png")
const shaker_small_ice_medium = preload("res://art/shaker-small-ice-medium.png")
const shaker_small_ice_large = preload("res://art/shaker-small-ice-large.png")
const shaker_large_ice_small = preload("res://art/shaker-large-ice-small.png")
const shaker_large_ice_medium = preload("res://art/shaker-large-ice-medium.png")
const shaker_large_ice_large = preload("res://art/shaker-large-ice-large.png")

const mouse_offset = Vector2.ZERO
var is_dragging = false

func _ready():
	var shape = hitbox_shape.shape.duplicate()
	hitbox_shape.shape = shape
	match shaker_size:
		"regular":
			shape.size = hitbox_size_medium
			hitbox_shape.position = hitbox_position_medium
		"large":
			shape.size = hitbox_size_large
			hitbox_shape.position = hitbox_psotion_large
			
			sprite.texture = shaker_large_texture
			
func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() - mouse_offset

# Called when player clicks the cup hitbox
func _on_hitbox_clicked() -> void:
	var current_scoop = ToolManager.get_current_scoop()
	
	match current_scoop:
		ToolManager.Tool.NONE:
			# No scoop → start dragging
			is_dragging = true
			#mouse_offset = get_global_mouse_position() - global_position
		ToolManager.Tool.SCOOP:
			# Scoop active → change cursor & cup sprite, no dragging
			ToolManager.scoop_press()
		ToolManager.Tool.SCOOP_ICE:
			ToolManager.scoop_press()
			match shaker_size:
				"regular":
					sprite.texture = shaker_small_ice_medium
				"large":
					sprite.texture = shaker_large_ice_medium
		#ToolManager.Tool.SCOOP_BOBA:
			# Scoop active → change cursor & cup sprite, no dragging
			#ToolManager.scoop_press()
			#sprite.texture = cup_boba
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		# Stop dragging if dragging
		if is_dragging:
			is_dragging = false

		# Always release scoop cursor if scoop tool is active
		var current_tool = ToolManager.current_tool
		if current_tool != ToolManager.Tool.NONE:
			ToolManager.scoop_release()
