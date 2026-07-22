class_name LevelInfo extends RefCounted

var connections: Dictionary[String, int]
var properties: Array[String]
var text: String

func _init(p_connections: Dictionary[String, int], p_properties: Array[String], p_text: String = "Whole lotta nothing..."):
	connections = p_connections
	properties = p_properties
	text = p_text

func set_text(p_text: String):
	text = p_text

func get_text() -> String:
	return text

func get_direction(direction: String) -> int:
	if connections.has(direction):
		return connections.get(direction)
	else:
		print("Oops! Direction doesn't exist.")
		return 0
