class_name Level extends Node2D

# Stores the connections for a certain room in a {direction: room number} format.
var level_connections: Dictionary = {}

@onready var left_sprite: Sprite2D = $Left
@onready var middle_sprite: Sprite2D = $Middle
@onready var right_sprite: Sprite2D = $Right

func _ready() -> void:
	print(left_sprite, $Left)

func setup(connections: Dictionary) -> void:
	level_connections = connections
	left_sprite.visible = connections.has("left")
	middle_sprite.visible = connections.has("forward")
	right_sprite.visible = connections.has("right")
