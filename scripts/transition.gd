extends Control

var current_scene = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	current_scene = get_tree().current_scene

func goto_scene(path: String):
	await fade_out()
	deferred_goto_scene.call_deferred(path)
	await fade_in()

func deferred_goto_scene(path: String):
	current_scene.free()
	var s = ResourceLoader.load(path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func fade_out():
	animation_player.play("fade")
	await animation_player.animation_finished

func fade_in():
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	
	
