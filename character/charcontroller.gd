extends CharacterBody2D
signal tookdamage
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
	
	var input_direction = Vector2(
		Input.get_action_strength("Right") - Input.get_action_strength("Left"),
		# up and down motion should be slower than left and right
		(Input.get_action_strength("Down") - Input.get_action_strength("Up")) * .7
	)
	
	update_animation_parameters(input_direction)
	if blocking == false && busy == false:
		velocity = input_direction * movespeed
		move_and_slide()
		pick_new_state()

func _unhandled_input(_event):
	if Input.is_action_just_released("Block"):
		unblock()

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
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = .5
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", self._on_timer_timeout)



func _on_animation_tree_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "jableft" or "jabright":
		busy = false


func _on_animation_player_animation_finished(anim_name):
	print(anim_name)

func takedamage(damage):
	if blocking == true:
		pass
	else:
		emit_signal("tookdamage")

func _on_timer_timeout() -> void:
	busy = false
