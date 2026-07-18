extends Node2D

@onready var level_container: Node2D = $LevelContainer
const LEVEL = preload("uid://jmcyftqrnl7m")

var room_data: Array[Dictionary] = [
	{forward = 1},
	{back = 0, forward = 2},
	{back = 1, forward = 4, right = 3},
	{left = 2},
	{back = 2}
]

@onready var left: Button = $CanvasLayer/Control/Left
@onready var forward: Button = $CanvasLayer/Control/Forward
@onready var right: Button = $CanvasLayer/Control/Right
@onready var back: Button = $CanvasLayer/Control/Back

var rooms: Array[Level] = []

var current_room_index := 0 # Tracks the current room.

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
	rooms[current_room_index].hide()
	current_room_index = new_room_index
	rooms[new_room_index].show()
	draw_buttons(new_room_index)


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
