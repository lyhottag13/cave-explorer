extends Control

signal combo_checked(combo: Array[int])
signal puzzle_menu_closed

@onready var slot_1: Slot = %SlotButton1
@onready var slot_2: Slot = %SlotButton2
@onready var slot_3: Slot = %SlotButton3

func _ready() -> void:
	slot_1.setup(1)
	slot_2.setup(2)
	slot_3.setup(3)

func _on_check_button_pressed() -> void:
	var combination: Array[int] = [slot_1.get_slot(), slot_2.get_slot(), slot_3.get_slot()]
	combo_checked.emit(combination)

func _on_close_button_pressed() -> void:
	puzzle_menu_closed.emit()
	hide()
