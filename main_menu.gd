extends Control

@onready var start_game: Button = $VBoxContainer/StartGame
@onready var end_game: Button = $VBoxContainer/EndGame

func _on_start_game_pressed() -> void:
	Transition.goto_scene("uid://de4w73fy436aa")

func _on_end_game_pressed() -> void:
	get_tree().quit()
