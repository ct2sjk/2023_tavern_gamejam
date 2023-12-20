extends Node2D
var maxenemies = 1
var enemies = 1
var enemy = preload("res://Enemy/enemy.tscn")
var point = 50

func _process(_delta):
	Global.player_position = $player.position
	if enemies<maxenemies:
		while enemies<maxenemies:
			var enemy_instance = enemy.instantiate()
			enemy_instance.position = Vector2(-80,100)
			add_child(enemy_instance)
			enemies+=1
	
	if Global.time<point:
		maxenemies +=1
		point = point - 10
func _on_timer_timeup(value):
	get_tree().change_scene_to_file("res://Endscreen.tscn")


