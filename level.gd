class_name Level extends Node2D

# Stores the connections for a certain room in a {direction: room number} format.
var level_connections: Dictionary = {}
var text: String

@onready var background: AnimatedSprite2D = $Background


@onready var left_sprite: Sprite2D = $Left
@onready var middle_sprite: Sprite2D = $Middle
@onready var right_sprite: Sprite2D = $Right

func setup(connections: Dictionary) -> void:
	level_connections = connections
	left_sprite.visible = connections.has("left")
	middle_sprite.visible = connections.has("forward")
	right_sprite.visible = connections.has("right")
	if connections.has("creepy"):
		play_creepy()

func play_creepy() -> void:
	background.animation = "creepy"
