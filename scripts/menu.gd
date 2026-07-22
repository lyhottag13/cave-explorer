class_name Menu extends Control

signal act
signal show_map

@onready var act_button: Button = %Act
@onready var text_label: Label = %TextLabel

func _process(_delta: float) -> void:
	pass

func _on_act_pressed() -> void:
	act.emit()

func show_text(text: String) -> void:
	text_label.text = "* " + text


func _on_map_pressed() -> void:
	show_map.emit()
