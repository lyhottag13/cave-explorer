extends Control

@onready var mag: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Mag
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var transition: Control = $Transition

func _process(_delta: float) -> void:
	pass

func _on_mag_pressed() -> void:
	canvas_layer.show()
	await Utils.sleep(1)
	canvas_layer.hide()
