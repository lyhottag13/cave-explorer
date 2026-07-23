class_name SFX extends AudioStreamPlayer

var explosion = preload("res://assets/sounds/roblox-explosion-sound.mp3")
var funk = preload("res://assets/sounds/funk.mp3")

func play_sfx(sfx_name: String) -> void:
	match sfx_name:
		"explosion":
			stream = explosion
		"funk":
			stream = funk
	play()
