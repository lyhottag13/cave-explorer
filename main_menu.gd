extends Control

@onready var start_game: Button = $VBoxContainer/StartGame
@onready var end_game: Button = $VBoxContainer/EndGame
@onready var transition: Control = $Transition

func _on_start_game_pressed() -> void:
	Transition.goto_scene("uid://c5bkwwy3hxu0y")

func _on_end_game_pressed() -> void:
	get_tree().quit()
