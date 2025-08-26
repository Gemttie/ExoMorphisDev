extends Node2D

func _ready() -> void:
	call_deferred("_deferred_change_scene")

func _deferred_change_scene() -> void:
	get_tree().change_scene_to_file("res://data/scenes/intro_stage.tscn")
