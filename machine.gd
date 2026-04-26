extends Node2D

var is_occupied := false

# Pouring state
var is_pouring := false
var pour_height := 0.0
const POUR_SPEED := 1500.0      # pixels per second
const POUR_MAX_HEIGHT := 330.0 # how tall the liquid gets
const POUR_WIDTH := 25.0       # width of the stream

@onready var hitbox = $Hitbox

func _ready():
	hitbox.connect("clicked", _on_clicked)

func _on_clicked():
	is_pouring = true
	print("is pouring")

func _process(delta):
	if is_pouring:
		pour_height = min(pour_height + POUR_SPEED * delta, POUR_MAX_HEIGHT)
		queue_redraw()

func _draw():
	if is_pouring or pour_height > 0:
		var pour_origin = Vector2(0, 60)
		var rect = Rect2(
			pour_origin.x - POUR_WIDTH / 2,
			pour_origin.y,
			POUR_WIDTH,
			pour_height
		)
		draw_rect(rect, Color("#D0AE84"))

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		if is_pouring:
			is_pouring = false
			pour_height = 0.0
			queue_redraw()
