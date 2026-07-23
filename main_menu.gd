extends Control

@onready var start_game: Button = $VBoxContainer/StartGame
@onready var end_game: Button = $VBoxContainer/EndGame
@onready var game_done_screen: Control = $"GameDoneScreen"

func _ready() -> void:
	#game_done_screen.visible = FileAccess.file_exists("user://game_done")
	pass

func _on_start_game_pressed() -> void:
	Transition.goto_scene("uid://de4w73fy436aa")

func _on_end_game_pressed() -> void:
	get_tree().quit()
