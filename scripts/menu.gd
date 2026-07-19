extends Control

signal act

@onready var act_button: Button = %Act
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var text_label: Label = %TextLabel

func _process(_delta: float) -> void:
	pass

func _on_act_pressed() -> void:
	act.emit()

func show_text(text: String) -> void:
	text_label.text = "* " + text
