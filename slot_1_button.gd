class_name Slot extends Button

var current_slot := 0

var slot_textures = [] # An array of the three textures the slot can display. For now, just letters

func setup(p_slot_textures):
	slot_textures = p_slot_textures
	text = slot_textures[0]

func increment():
	current_slot = (current_slot + 1) % 3
	text = slot_textures[current_slot]

func get_slot() -> int:
	return current_slot
