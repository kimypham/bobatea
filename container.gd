extends Area2D

@onready var sprite = $ContainerSprite

@export var contains: String = "boba"

const boba_texture = preload("res://art/container-boba.png")
const ice_texture = preload("res://art/container-ice.png")

func _ready():
	match contains:
		"boba":
			sprite.texture = boba_texture
			sprite.tool_action = "scoop_boba"
		"ice":
			sprite.texture = ice_texture
			sprite.tool_action = "scoop_ice"
