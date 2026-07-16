extends Node

func sleep(time: float) -> Signal:
	return get_tree().create_timer(time).timeout
