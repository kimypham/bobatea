extends Node2D

@export var cup_size: String = "regular"

@onready var sprite = $GenerateCupSprite
@onready var hitbox = $Hitbox
@onready var hitbox_shape = $Hitbox/GenerateCupHitbox

var cup_scene = preload("res://cup.tscn")

var cup_large = preload("res://art/cup-generator-large.png")

const hitbox_size_medium: Vector2 = Vector2(125, 220)
const hitbox_position_medium: Vector2 = Vector2(0, 0)

const hitbox_size_large: Vector2 = Vector2(125, 300)
const hitbox_position_large: Vector2 = Vector2(0, 0)

func _ready():
	hitbox.connect("clicked", _on_clicked)
	
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
		

func _on_clicked():
	var new_cup = cup_scene.instantiate()
	new_cup.global_position = global_position
	new_cup.cup_size = cup_size
	get_parent().add_child(new_cup)
	
	new_cup.start_dragging()
