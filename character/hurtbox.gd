class_name hurtbox
extends Area2D

func _init():
	self.collision_layer = 0
	self.collision_mask = 2
	
func _ready():
	connect ("area_entered", self._areaentered)

func _areaentered(box: hitbox):
	
	if hitbox == null or box.owner == self.owner:
		return
	owner.takedamage(box.damage)
