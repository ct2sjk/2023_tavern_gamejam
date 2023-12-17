extends CharacterBody2D

@export var movespeed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)
#parameters/idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
func _ready():
	print("hello")
	update_animation_parameters(starting_direction)
	
func _physics_process(_delta):
	
	var input_direction = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		# up and down motion should be slower than left and right
		(Input.get_action_strength("Down") - Input.get_action_strength("Up")) * .7
	)
	
	update_animation_parameters(input_direction)
	
	velocity = input_direction * movespeed
	move_and_slide()
	pick_new_state()

func _unhandled_input(event):
	print (event)

func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO):
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input[0])
		animation_tree.set("parameters/idle/blend_position",move_input[0])
func pick_new_state():
	
	#if block is held play block animation
	if Input.is_action_pressed("Block"):
		state_machine.travel("block")
	#if velocity is non zero play coresponding walk animation
	elif (velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
