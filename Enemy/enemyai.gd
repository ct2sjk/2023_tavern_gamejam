extends CharacterBody2D
@export var movespeed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)
#parameters/idle/blend_position
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

#import hitbox scene for attacks
var hitbox = preload("res://character/hitbox.tscn")

#direction of the character
var direction = 1

#variable set to true when an animation is going
var busy = false

#wether the character is in the blocking state
var blocking = false

func _ready():
	print("hello")
	update_animation_parameters(starting_direction)
	
func _physics_process(_delta):
	
	var input_direction = Vector2(0,0)
	
	update_animation_parameters(input_direction)
	if blocking == false && busy == false:
		velocity = input_direction * movespeed
		move_and_slide()
		pick_new_state()



func update_animation_parameters(move_input : Vector2):
	if (move_input != Vector2.ZERO) && busy == false:
		
		#set the position of the point in all of the animation spaces
	
		animation_tree.set("parameters/walk/blend_position", move_input)
		animation_tree.set("parameters/idle/blend_position", move_input[0])
		animation_tree.set("parameters/block/blend_position",move_input[0])
		animation_tree.set("parameters/jab/blend_position",move_input[0])
		
		#set the direction of the character
		setdirection(move_input[0])
		
		

func setdirection(value):
	if value<0:
		direction = 0
	elif value>0:
		direction = 1
func pick_new_state():
	
	if busy == true:
		pass
	#if block is held play block animation
	elif Input.is_action_pressed("Block"):
		block()

	elif Input.is_action_pressed("Punch"):
		punch()
	#if velocity is non zero play coresponding walk animation
	elif (velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")

func create_hitbox(width, height, offset,time):
	var hitbox_instance = hitbox.instantiate()
	hitbox_instance.position = offset
	add_child(hitbox_instance)
	hitbox_instance.setvariables(width,height,time)
	
	
func block():
	state_machine.travel("block")
	blocking = true
	
func unblock():
	blocking = false
	
#needs to set state to busy and lock animation to punching then initiate the hitbox
func punch():
	state_machine.travel("jab")
	busy = true
	if direction == 1:
		create_hitbox(1,.6,Vector2(22,-17),.5)
	else:
		create_hitbox(1,.6,Vector2(-20,-17),.5)




func _on_animation_tree_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "jableft" or "jabright":
		busy = false


func _on_animation_player_animation_finished(anim_name):
	print(anim_name)
