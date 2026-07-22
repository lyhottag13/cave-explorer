extends Node2D

@onready var level_container: Node2D = $LevelContainer
const LEVEL = preload("uid://jmcyftqrnl7m")

var inventory: Array[String] = []

var room_props: Array[LevelInfo] = [
	LevelInfo.new({forward = 1}, []),
	LevelInfo.new({back = 0, forward = 2}, []),
	LevelInfo.new(
		{back = 1, forward = 4, right = 3},
		["debris"],
		"There's debris in the way!"
	),
	LevelInfo.new(
		{left = 2},
		["dynamite"],
		"There's a stick of dynamite on the floor."
	),
	LevelInfo.new({back = 2, forward = 5}, []),
	LevelInfo.new(
		{back = 4, left = 6, right = 8, forward = 9},
		["locked_door"],
		"There's a locked door with a code."
	),
	LevelInfo.new({left = 7, right = 5}, ["slot1"]),
	LevelInfo.new({right = 6}, ["slot2"]),
	LevelInfo.new({left = 5}, ["slot3"]),
	LevelInfo.new(
		{},
		["creepy"],
		"HELP ME HELP ME HELP ME HELP ME HELP ME HELP ME HELP ME HELP ME "
	)
]

@onready var left: Button = %Left
@onready var forward: Button = %Forward
@onready var right: Button = %Right
@onready var back: Button = %Back

@onready var menu: Menu = %Menu
@onready var puzzle_menu: Control = %PuzzleMenu
@onready var map: Control = %Map
@onready var music: AudioStreamPlayer = %Music

var rooms: Array[Level] = []

var current_room_index := 0 # Tracks the current room.

var is_debris_cleared := false
var is_puzzle_solved := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in len(room_props):
		var new_room: Level = LEVEL.instantiate()
		add_child(new_room)
		new_room.hide()
		new_room.setup(room_props[i].connections, room_props[i].properties, room_props[i].text)
		rooms.append(new_room)
	rooms[current_room_index].show()
	draw_buttons(current_room_index)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_down"):
		back.pressed.emit()
	elif Input.is_action_just_pressed("move_left"):
		left.pressed.emit()
	elif Input.is_action_just_pressed("move_up"):
		forward.pressed.emit()
	elif Input.is_action_just_pressed("move_right"):
		right.pressed.emit()

func draw_buttons(room_index: int):
	var room: Dictionary[String, int] = room_props[room_index].connections
	forward.visible = room.has("forward")
	left.visible = room.has("left")
	right.visible = room.has("right")
	back.visible = room.has("back")

func switch_room(new_room_index: int) -> void:
	if new_room_index == 4 && not is_debris_cleared:
		menu.show_text("The debris blocks you.")
		return
	elif new_room_index == 9 && not is_puzzle_solved:
		menu.show_text("The locked door blocks you.")
		return
	elif new_room_index == 9 && is_puzzle_solved:
		handle_final_room(new_room_index)
	elif new_room_index == -1:
		return
	else:
		rooms[current_room_index].hide()
		current_room_index = new_room_index
		rooms[current_room_index].show()
		draw_buttons(current_room_index)
		menu.show_text(rooms[current_room_index].text)


# Below functions are VERY FRAGILE because if there's a button drawn for a direction that does not exist, the code will BREAK.
func _on_forward_pressed() -> void:
	var new_room_index: int = room_props[current_room_index].get_direction("forward")
	switch_room(new_room_index)

func _on_right_pressed() -> void:
	var new_room_index: int = room_props[current_room_index].get_direction("right")
	switch_room(new_room_index)

func _on_left_pressed() -> void:
	var new_room_index: int = room_props[current_room_index].get_direction("left")
	switch_room(new_room_index)

func _on_back_pressed() -> void:
	var new_room_index: int = room_props[current_room_index].get_direction("back")
	switch_room(new_room_index)

func _on_menu_act() -> void:
	if current_room_index == 3 && not inventory.has("dynamite"):
		rooms[3].hide_dynamite()
		inventory.append("dynamite")
		print("Dynamite Collected!")
		rooms[current_room_index].text = "You got the dynamite!"
		rooms[2].text = "This looks bombable..."
		menu.show_text(rooms[current_room_index].text)
	elif current_room_index == 2 && inventory.has("dynamite") && not is_debris_cleared:
		inventory.erase("dynamite")
		await rooms[2].show_dynamite()
		is_debris_cleared = true
		rooms[2].hide_debris()
		print("Explosion!")
		rooms[current_room_index].text = "The debris is cleared!"
		menu.show_text(rooms[current_room_index].text)
	elif current_room_index == 5 && not is_puzzle_solved:
		show_puzzle()

func show_puzzle():
	puzzle_menu.show()

func _on_puzzle_menu_combo_checked(correct: bool) -> void:
	is_puzzle_solved = correct
	if is_puzzle_solved:
		rooms[current_room_index].text = "The door swings open!"
		menu.show_text(rooms[current_room_index].text)
		rooms[5].open_door()

func handle_final_room(new_room_index: int) -> void:
	music.stop()
	menu.show_text("")
	rooms[current_room_index].hide()
	current_room_index = new_room_index
	rooms[new_room_index].show()
	draw_buttons(new_room_index)
	menu.show_text(rooms[new_room_index].text)
	await Utils.sleep(1)
	get_tree().quit()

func _on_menu_show_map() -> void:
	map.show()
