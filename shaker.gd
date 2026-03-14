extends Node2D

@onready var sprite = $ShakerSprite
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/ShakerHitbox

@export var cup_size: String = "regular"

const hitbox_size_medium: Vector2 = Vector2(145, 360)
const hitbox_position_medium: Vector2 = Vector2(0, -50)

const hitbox_size_large: Vector2 = Vector2(145, 370)
const hitbox_psotion_large: Vector2 = Vector2(0, -25)
const shaker_large_texture = preload("res://art/shaker-large.png")

const mouse_offset = Vector2.ZERO
var is_dragging = false

func _ready():
	var shape = hitbox_shape.shape.duplicate()
	hitbox_shape.shape = shape
	match cup_size:
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

func _on_hitbox_clicked() -> void:
	is_dragging = true
	
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if is_dragging:
			is_dragging = false
