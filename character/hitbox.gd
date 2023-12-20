class_name hitbox
extends Area2D

@export var damage := 10


func _init():
	self.collision_layer = 2
	self.collision_mask = 0
	


