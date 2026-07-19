extends Node2D

@onready var level_container: Node2D = $LevelContainer
const LEVEL = preload("uid://jmcyftqrnl7m")

var inventory: Array[String] = []

var room_data: Array[Dictionary] = [
	{forward = 1},
	{back = 0, forward = 2},
	{back = 1, forward = 4, right = 3},
	{left = 2, dynamite = true},
	{back = 2, forward = 5, debris = true},
	{back = 4, left = 6, right = 8, forward = 9},
	{left = 7, right = 5},
	{right = 6},
	{left = 5},
	{creepy = true}
]

var room_text: Array[String] = [
	"Whole lotta nothing...",
	"Whole lotta nothing...",
	"There's debris in the way!",
	"There's a stick of dynamite on the floor.",
	"Whole lotta nothing...",
	"There's a locked door with a code.",
	"Whole lotta nothing...",
	"Whole lotta nothing...",
	"Whole lotta nothing...",
	"HELP ME HELP ME HELP ME HELP ME HELP ME HELP ME HELP ME HELP ME "
]

@onready var left: Button = %Left
@onready var forward: Button = %Forward
@onready var right: Button = %Right
@onready var back: Button = %Back

@onready var menu: Control = %Menu
@onready var puzzle_menu: Control = %PuzzleMenu
@onready var music: AudioStreamPlayer = %Music

var rooms: Array[Level] = []

var current_room_index := 0 # Tracks the current room.

var is_debris_cleared := false
var is_puzzle_solved := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for room in room_data:
		var new_room := LEVEL.instantiate()
		add_child(new_room)
		new_room.hide()
		new_room.setup(room)
		rooms.append(new_room)
	rooms[current_room_index].show()
	draw_buttons(current_room_index)

func draw_buttons(room_index: int):
	var room = room_data[room_index]
	forward.visible = room.has("forward")
	left.visible = room.has("left")
	right.visible = room.has("right")
	back.visible = room.has("back")

func switch_room(new_room_index: int):
	if new_room_index == 4 && not is_debris_cleared:
		menu.show_text("The debris blocks you.")
		return
	elif new_room_index == 9 && not is_puzzle_solved:
		menu.show_text("The locked door blocks you.")
		return
	elif new_room_index == 9 && is_puzzle_solved:
		music.stop()
		menu.show_text("")
		rooms[current_room_index].hide()
		current_room_index = new_room_index
		rooms[new_room_index].show()
		draw_buttons(new_room_index)
		menu.show_text(room_text[new_room_index])
		await Utils.sleep(1)
		get_tree().quit()
	else:
		rooms[current_room_index].hide()
		current_room_index = new_room_index
		rooms[new_room_index].show()
		draw_buttons(new_room_index)
		menu.show_text(room_text[new_room_index])


# Below functions are VERY FRAGILE because if there's a button drawn for a direction that does not exist, the code will BREAK.
func _on_forward_pressed() -> void:
	var new_room_index = room_data[current_room_index]["forward"]
	switch_room(new_room_index)

func _on_right_pressed() -> void:
	var new_room_index = room_data[current_room_index]["right"]
	switch_room(new_room_index)

func _on_left_pressed() -> void:
	var new_room_index = room_data[current_room_index]["left"]
	switch_room(new_room_index)

func _on_back_pressed() -> void:
	var new_room_index = room_data[current_room_index]["back"]
	switch_room(new_room_index)

func _on_menu_act() -> void:
	if current_room_index == 3 && not inventory.has("dynamite"):
		inventory.append("dynamite")
		print("got!")
		room_text[current_room_index] = "You got the dynamite!"
		room_text[2] = "This looks bombable..."
		menu.show_text(room_text[current_room_index])
	elif current_room_index == 2 && inventory.has("dynamite"):
		is_debris_cleared = true
		print("kaboom!")
		room_text[current_room_index] = "The debris is cleared!"
		menu.show_text(room_text[current_room_index])
	elif current_room_index == 5 && not is_puzzle_solved:
		show_puzzle()

func show_puzzle():
	puzzle_menu.show()

func _on_puzzle_menu_combo_checked(correct: bool) -> void:
	is_puzzle_solved = correct
	if is_puzzle_solved:
		room_text[current_room_index] = "The door swings open!"
		menu.show_text(room_text[current_room_index])
