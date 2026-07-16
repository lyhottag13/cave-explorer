extends Control

@onready var start_game: Button = $VBoxContainer/StartGame
@onready var end_game: Button = $VBoxContainer/EndGame
@onready var transition: Control = $Transition

const MENU = preload("uid://c5bkwwy3hxu0y")

func _on_start_game_pressed() -> void:
	await transition.fade_out()
	get_tree().change_scene_to_packed(MENU)

func _on_end_game_pressed() -> void:
	get_tree().quit()

func swap_to_game():
	get_tree().change_scene_to_packed(MENU)
