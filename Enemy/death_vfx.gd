extends Node

@export var deathParticle : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#kill function for particles to work
func Kill():
	var _particle = deathParticle.instantiate()
	_particle.position = self.global_position
	_particle.rotation = self.global_rotation
	_particle.emitting = true
	get_tree().current_scene.add_child(_particle)
	
	queue_free() 
