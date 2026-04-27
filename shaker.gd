extends Node2D

@onready var sprite = $ShakerSprite
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/ShakerHitbox
@onready var liquid_sprite = $LiquidSprite
@onready var liquid_sprite_transparent = $LiquidSpriteTransparent

@export var shaker_size: String = "regular"

const hitbox_size_medium: Vector2 = Vector2(145, 360)
const hitbox_position_medium: Vector2 = Vector2(0, -50)

const hitbox_size_large: Vector2 = Vector2(145, 370)
const hitbox_position_large: Vector2 = Vector2(0, -25)
const shaker_large_texture = preload("res://art/shaker-large.png")

const shaker_small_ice_small = preload("res://art/shaker-small-ice-small.png")
const shaker_small_ice_medium = preload("res://art/shaker-small-ice-medium.png")
const shaker_small_ice_large = preload("res://art/shaker-small-ice-large.png")
const shaker_large_ice_small = preload("res://art/shaker-large-ice-small.png")
const shaker_large_ice_medium = preload("res://art/shaker-large-ice-medium.png")
const shaker_large_ice_large = preload("res://art/shaker-large-ice-large.png")

const mouse_offset = Vector2.ZERO
var is_dragging = false

# --- Ingredient scenes ---
var ingredient_scenes = {
	"ice": preload("res://shaker_ice_sprite.tscn"),
}

var ingredient_scoops := {}  # tracks scoops per ingredient type

var spacing_y = 20  # adjust to your sprite height
const base_y_regular = 90     # starting Y position inside the cup (adjust to sit at the bottom)
const base_y_large = 125

@export var snap_target: Node2D = null
var snap_radius := 80.0                  # how close before it snaps (pixels)
var is_snapped := false

var liquid_fill := 0.0          # 0.0 to 1.0
const FILL_SPEED := 0.15        # how fast it fills per second

func _ready():
	add_to_group("shakers")
	liquid_sprite.visible = false
	liquid_sprite_transparent.visible = false
	
	var shape = hitbox_shape.shape.duplicate()
	hitbox_shape.shape = shape
	match shaker_size:
		"regular":
			shape.size = hitbox_size_medium
			hitbox_shape.position = hitbox_position_medium
		"large":
			shape.size = hitbox_size_large
			hitbox_shape.position = hitbox_position_large
			
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

			if is_snapped:
				is_snapped = false   # unsnap
				snap_target.is_occupied = false
		ToolManager.Tool.SCOOP:
			# Scoop active → change cursor & cup sprite, no dragging
			ToolManager.scoop_press()
		ToolManager.Tool.SCOOP_ICE:
			ToolManager.scoop_press()
			_add_scoop("ice")
		#ToolManager.Tool.SCOOP_BOBA:
			# Scoop active → change cursor & cup sprite, no dragging
			#ToolManager.scoop_press()
			#sprite.texture = cup_boba
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		# Stop dragging if dragging
		if is_dragging:
			is_dragging = false
			_try_snap()

		# Always release scoop cursor if scoop tool is active
		var current_tool = ToolManager.current_tool
		if current_tool != ToolManager.Tool.NONE:
			ToolManager.scoop_release()
			
func _try_snap():
	if snap_target == null:
		return
	if snap_target.is_occupied:
		return   # someone's already there
	var snap_point = snap_target.get_node("SnapPoint").global_position
	if global_position.distance_to(snap_point) <= snap_radius:
		global_position = snap_point
		is_snapped = true
		snap_target.is_occupied = true

func _add_scoop(ingredient: String):
	if not ingredient_scenes.has(ingredient):
		push_error("Unknown ingredient: " + ingredient)
		return
	
	var count = ingredient_scoops.get(ingredient, []).size()
	var new_sprite = ingredient_scenes[ingredient].instantiate()
	var base_y_based_on_size = base_y_regular
	if shaker_size == "large":
		base_y_based_on_size = base_y_large
	new_sprite.position = Vector2(0, base_y_based_on_size - count * spacing_y)
	add_child(new_sprite)
	move_child(new_sprite, 1)
	
	if not ingredient_scoops.has(ingredient):
		ingredient_scoops[ingredient] = []
	ingredient_scoops[ingredient].append(new_sprite)
	
func receive_liquid(delta: float):
	liquid_fill = min(liquid_fill + FILL_SPEED * delta, 1.0)
	liquid_sprite.visible = true
	liquid_sprite_transparent.visible = true
	
	var tex_size = liquid_sprite.texture.get_size()
	var fill_height = tex_size.y * liquid_fill
	var y_offset = tex_size.y - fill_height  # how much to crop from the top
	
	liquid_sprite.region_enabled = true
	liquid_sprite.region_rect = Rect2(0, y_offset, tex_size.x, fill_height)
	liquid_sprite.offset = Vector2(0, y_offset / 2.0)
	
	# repeat the same for transparent to make ingredients look submerged
	liquid_sprite_transparent.region_enabled = true
	liquid_sprite_transparent.region_rect = Rect2(0, y_offset, tex_size.x, fill_height)
	liquid_sprite_transparent.offset = Vector2(0, y_offset / 2.0)
