class_name Slot extends Button

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var current_slot := 0

func setup(slot_number: int) -> void:
	animated_sprite_2d.animation = "slot" + str(slot_number)

func increment():
	current_slot = (current_slot + 1) % 3
	animated_sprite_2d.frame = current_slot

func get_slot() -> int:
	return current_slot

func _on_pressed() -> void:
	increment()
