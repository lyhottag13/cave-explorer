class_name Player extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func play_thumbs_up():
	animated_sprite_2d.play("thumbs_up")
	await animated_sprite_2d.animation_finished
	animated_sprite_2d.play("idle")
