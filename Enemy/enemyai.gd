extends CharacterBody2D
@export var movespeed : float = 70
@export var starting_direction : Vector2 = Vector2(0,1)
@export var health = 100
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
	update_animation_parameters(starting_direction)
	
func _physics_process(_delta):
	
	var input_direction = Vector2(0,0)
	
	if blocking == false && busy == false:
		if (position[0] < Global.player_position[0]+40 && position[0] > Global.player_position[0]-40) && position.distance_to(Global.player_position)<60:
			punch()
		else:
			velocity = position.direction_to(Global.player_position) * movespeed
			update_animation_parameters(velocity)
			#velocity = input_direction * movespeed
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
	elif (velocity != Vector2.ZERO):
		state_machine.travel("walk")
	else:
		state_machine.travel("idle")
	#elif Input.is_action_pressed("Block"):
		#block()

	#elif Input.is_action_pressed("Punch"):
		#punch()

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

func _on_timer_timeout() -> void:
	busy = false
	
func _on_animation_tree_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "jableft" or "jabright":
		busy = false


func _on_animation_player_animation_finished(anim_name):
	print(anim_name)

func takedamage(input):
	Global.score += input
	health -= input
	if health <= 0:
		queue_free()
