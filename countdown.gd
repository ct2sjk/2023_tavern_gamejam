extends Label

#amount the timer starts at
@export var starttime = 60

#multiplier for time subtraction
@export var timerate = 1.0 

#time left in level
var time = 0

#initialize time variable value with level start
func _levelstart():
	time = starttime
	
#update time on every frame
func _process(delta):
	time -= delta
