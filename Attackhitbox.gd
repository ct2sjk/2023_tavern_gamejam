extends Node2D
var sprite = Sprite2D
@export var width = 10
@export var height = 10
@onready var timer = $Timer
func setvariables(w,h,time):
	width = w
	height = h
	visualize(w,h)
	timer.wait_time = time
	timer.start()
	
func visualize(width,height):
	self.scale = Vector2(width,height)


func _on_timer_timeout():
	queue_free()
