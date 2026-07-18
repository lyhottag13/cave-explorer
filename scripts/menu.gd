extends Control

@onready var mag: Button = %Mag
@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _process(_delta: float) -> void:
	pass

func _on_mag_pressed() -> void:
	canvas_layer.show()
	await Utils.sleep(1)
	canvas_layer.hide()
