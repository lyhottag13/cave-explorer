extends Node2D

@onready var level_container: Node2D = $LevelContainer
const LEVEL = preload("uid://jmcyftqrnl7m")

var inventory: Array[String] = []

var correct_combination: Array[int] = [randi_range(0, 2), randi_range(0, 2), randi_range(0, 2)]

var room_props: Array[LevelInfo] = [
	LevelInfo.new({forward = 1}),
	LevelInfo.new({back = 0, forward = 2}),
	LevelInfo.new(
		{back = 1, forward = 4, right = 3},
		{debris = null},
		"There's debris in the way!"
	),
	LevelInfo.new(
		{left = 2},
		{dynamite = null},
		"There's a stick of dynamite on the floor."
	),
	LevelInfo.new({back = 2, forward = 5}),
	LevelInfo.new(
		{back = 4, left = 6, right = 8, forward = 9},
		{locked_door = null},
		"There's a locked door with a code."
	),
	LevelInfo.new({left = 7, right = 5}, {slot = {slot_number = 1, correct_index = correct_combination[0]}}),
	LevelInfo.new({right = 6}, {slot = {slot_number = 2, correct_index = correct_combination[1]}}),
	LevelInfo.new({left = 5}, {slot = {slot_number = 3, correct_index = correct_combination[2]}}),
	LevelInfo.new(
		{},
		{the_door = null},
		"Well, there is a door here."
	)
]

@onready var left: TextureButton = %Left
@onready var forward: TextureButton = %Forward
@onready var right: TextureButton = %Right
@onready var back: TextureButton = %Back

@onready var menu: Menu = %Menu
@onready var puzzle_menu: Control = %PuzzleMenu
@onready var map: Control = %Map
@onready var music: AudioStreamPlayer = %Music
@onready var player: Player = %Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var buttons: Control = %Buttons

var rooms: Array[Level] = []

var current_room_index := 0 # Tracks the current room.

var is_debris_cleared := false
var is_puzzle_solved := false
var can_move := false
var can_act := false
var can_open_map := false

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
	rooms[9].the_door_pressed.connect(door_pressed)
	menu.show_text("Time to explore...")
	# Sleeps so that the player can't move during the fade in.
	await Utils.sleep(1)
	can_move = true
	can_act = true
	can_open_map = true

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
	buttons.show()
	var room: Dictionary[String, int] = room_props[room_index].connections
	forward.visible = room.has("forward")
	left.visible = room.has("left")
	right.visible = room.has("right")
	back.visible = room.has("back")

func hide_buttons() -> void:
	buttons.hide()

func switch_room(new_room_index: int) -> void:
	if can_move:
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
			hide_buttons()
			can_act = false
			can_move = false
			can_open_map = false
			await Transition.goto_level(rooms[current_room_index], rooms[new_room_index])
			can_move = true
			can_act = true
			can_open_map = true
			current_room_index = new_room_index
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
	if can_act:
		if current_room_index == 3 && not inventory.has("dynamite"):
			handle_dynamite()
		elif current_room_index == 2 && inventory.has("dynamite") && not is_debris_cleared:
			handle_explosion()
		elif current_room_index == 5 && not is_puzzle_solved:
			show_puzzle()

func show_puzzle():
	puzzle_menu.show()
	can_move = false

var new_music = load("uid://bqcnvvlpw35a0")

func handle_final_room(new_room_index: int) -> void:
	music.stream = new_music
	music.play()
	menu.show_text("")
	rooms[current_room_index].hide()
	current_room_index = new_room_index
	rooms[new_room_index].show()
	draw_buttons(new_room_index)
	menu.show_text(rooms[new_room_index].text)

func handle_dynamite() -> void:
	can_act = false
	can_open_map = false
	can_move = false
	inventory.append("dynamite")
	print("Dynamite Collected!")
	rooms[2].text = "This looks bombable..."
	rooms[current_room_index].text = "You got the dynamite!"
	menu.show_text(rooms[current_room_index].text)
	rooms[3].hide_dynamite()
	map.hide()
	animation_player.play("thumbs_up")
	await animation_player.animation_finished
	can_move = true
	can_act = true
	can_open_map = true

func handle_explosion() -> void:
	can_act = false
	can_open_map = false
	can_move = false
	map.hide()
	inventory.erase("dynamite")
	rooms[2].show_dynamite()
	animation_player.play("explosion_start")
	await animation_player.animation_finished
	is_debris_cleared = true
	rooms[2].hide_debris()
	print("Explosion!")
	animation_player.play("explosion_end")
	await animation_player.animation_finished
	rooms[current_room_index].text = "The debris is cleared!"
	menu.show_text(rooms[current_room_index].text)
	can_move = true
	can_act = true
	can_open_map = true

func _on_menu_show_map() -> void:
	if can_open_map:
		map.show()
		can_move = false
		can_act = false

func _on_puzzle_menu_combo_checked(combo: Array[int]) -> void:
	print(correct_combination, combo)
	if combo == correct_combination:
		rooms[5].open_door()
		puzzle_menu.hide()
		rooms[current_room_index].text = "The door swings open!"
		is_puzzle_solved = true
		menu.show_text(rooms[current_room_index].text)
		animation_player.play("thumbs_up")
		await animation_player.animation_finished
		can_move = true

func _on_map_map_closed() -> void:
	can_move = true
	can_act = true
	
func _on_puzzle_menu_puzzle_menu_closed() -> void:
	can_move = true
	
func door_pressed() -> void:
	OS.shell_open("https://lyhottag13.github.io/shop")
	if OS.get_name() == "Web":
		await get_window().focus_exited
		player.hide()
	else:
		get_tree().quit()
