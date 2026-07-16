extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	hide()

func fade_in():
	show()
	animation_player.play("fade_in")
	await animation_player.animation_finished
	hide()

func fade_out():
	show()
	animation_player.play("fade_out")
	await animation_player.animation_finished
	hide()
