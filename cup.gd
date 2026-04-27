extends Node2D

# --- References ---
@onready var sprite = $EmptyCupSprite
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/CupHitbox

@export var cup_size: String = "regular"

const hitbox_size_medium: Vector2 = Vector2(125, 220)
const hitbox_position_medium: Vector2 = Vector2(0, 0)

const hitbox_size_large: Vector2 = Vector2(125, 300)
const hitbox_position_large: Vector2 = Vector2(0, 0)

# --- Dragging ---
var is_dragging = false
var mouse_offset = Vector2.ZERO

# --- Textures ---
var cup_boba = preload("res://art/cup-boba.png")
var cup_large = preload("res://art/cup-large.png")

# --- Ingredient scenes ---
var ingredient_scenes = {
	"boba": preload("res://bottom_boba_sprite.tscn"),
}

var ingredient_scoops := {}  # tracks scoops per ingredient type

var spacing_y = 20  # adjust to your sprite height
var base_y_regular = 45     # starting Y position inside the cup (adjust to sit at the bottom)
var base_y_large = 85

func _ready():
	hitbox.connect("clicked", Callable(self, "_on_cup_hitbox_clicked"))
	
	var shape = hitbox_shape.shape.duplicate()
	hitbox_shape.shape = shape
	match cup_size:
		"regular":
			shape.size = hitbox_size_medium
			hitbox_shape.position = hitbox_position_medium
		"large":
			shape.size = hitbox_size_large
			hitbox_shape.position = hitbox_position_large
			
			sprite.texture = cup_large

func _process(delta):
	if is_dragging:
		global_position = get_global_mouse_position() - mouse_offset

func _on_cup_hitbox_clicked() -> void:
	var current_scoop = ToolManager.get_current_scoop()
	
	match current_scoop:
		ToolManager.Tool.NONE:
			# No scoop → start dragging
			is_dragging = true
			mouse_offset = get_global_mouse_position() - global_position
		ToolManager.Tool.SCOOP:
			# Scoop active → change cursor & cup sprite, no dragging
			ToolManager.scoop_press()
		ToolManager.Tool.SCOOP_BOBA:
			# Scoop active → change cursor & cup sprite, no dragging
			ToolManager.scoop_press()
			_add_scoop("boba")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		# Stop dragging if dragging
		if is_dragging:
			is_dragging = false

		# Always release scoop cursor if scoop tool is active
		var current_tool = ToolManager.current_tool
		if current_tool != ToolManager.Tool.NONE:
			ToolManager.scoop_release()
			
func start_dragging():
	is_dragging = true
	mouse_offset = Vector2.ZERO  # cursor is already at the cup's position
			
func _add_scoop(ingredient: String):
	if not ingredient_scenes.has(ingredient):
		push_error("Unknown ingredient: " + ingredient)
		return
	
	var count = ingredient_scoops.get(ingredient, []).size()
	var new_sprite = ingredient_scenes[ingredient].instantiate()
	var base_y_based_on_size = base_y_regular
	if cup_size == "large":
		base_y_based_on_size = base_y_large
	new_sprite.position = Vector2(0, base_y_based_on_size - count * spacing_y)
	add_child(new_sprite)
	move_child(new_sprite, 0)
	
	if not ingredient_scoops.has(ingredient):
		ingredient_scoops[ingredient] = []
	ingredient_scoops[ingredient].append(new_sprite)
