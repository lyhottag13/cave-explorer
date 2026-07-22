extends Control

signal map_closed

func _on_close_button_pressed() -> void:
	hide()
	map_closed.emit()
