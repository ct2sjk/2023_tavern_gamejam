extends Node2D



func _on_timer_timeup(value):
	get_tree().change_scene_to_file("res://Endscreen.tscn")
