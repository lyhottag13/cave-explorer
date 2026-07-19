extends Control

signal combo_checked(correct: bool)

@onready var slot_1: Slot = %Slot1
@onready var slot_2: Slot = %Slot2
@onready var slot_3: Slot = %Slot3

const TEST_SLOTS := ["A", "B", "C"]

func _ready() -> void:
	slot_1.setup(TEST_SLOTS)
	slot_2.setup(TEST_SLOTS)
	slot_3.setup(TEST_SLOTS)

func _on_slot_pressed() -> void:
	slot_1.increment()

func _on_slot_2_pressed() -> void:
	slot_2.increment()

func _on_slot_3_pressed() -> void:
	slot_3.increment()

func _on_check_button_pressed() -> void:
	var correct_combination = slot_1.get_slot() == 0 && slot_2.get_slot() == 1 && slot_3.get_slot() == 2
	if correct_combination:
		combo_checked.emit(true)
		queue_free()
	else:
		combo_checked.emit(false)

func _on_close_button_pressed() -> void:
	hide()
