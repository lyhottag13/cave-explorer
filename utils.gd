extends Node

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

func sleep(time: float) -> Signal:
	return get_tree().create_timer(time).timeout
