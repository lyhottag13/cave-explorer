extends Control

@onready var mag: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Mag
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready() -> void:
	canvas_layer.hide()

func _process(_delta: float) -> void:
	pass

func _on_mag_pressed() -> void:
	canvas_layer.show()
	await sleep(1)
	canvas_layer.hide()

func sleep(time: float):
	return get_tree().create_timer(time).timeout
