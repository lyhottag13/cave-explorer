class_name Level extends Node2D

# Stores the connections for a certain room in a {direction: room number} format.
var connections: Dictionary = {}
var text: String

@onready var background: AnimatedSprite2D = $Background


@onready var left_sprite: Sprite2D = $Left
@onready var middle_sprite: Sprite2D = $Middle
@onready var right_sprite: Sprite2D = $Right
@onready var debris: Sprite2D = $Debris
@onready var locked_door: AnimatedSprite2D = $LockedDoor
@onready var dynamite: AnimatedSprite2D = $Dynamite

func setup(p_connections: Dictionary, p_properties: Array) -> void:
	connections = p_connections
	left_sprite.visible = p_connections.has("left")
	middle_sprite.visible = p_connections.has("forward")
	right_sprite.visible = p_connections.has("right")
	if p_properties.has("creepy"):
		play_creepy()
	debris.visible = p_properties.has("debris")
	locked_door.visible = p_properties.has("locked_door")
	dynamite.visible = p_properties.has("dynamite")

func play_creepy() -> void:
	background.animation = "creepy"

func open_door() -> void:
	locked_door.animation = "open"

func hide_debris() -> void:
	debris.hide()

func hide_dynamite() -> void:
	dynamite.hide()

func show_dynamite() -> void:
	dynamite.show()
	dynamite.animation = "lit"
	await dynamite.animation_finished
	print("Hey!")
	dynamite.hide()
