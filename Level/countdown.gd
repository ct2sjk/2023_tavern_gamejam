extends Label
signal timeup(value)
#amount the timer starts at
@export var starttime = 60.0

#multiplier for time subtraction
@export var timerate = 1.0 

#time left in level
var time = 0.0

#initialize time variable value with level start
func _ready():
	time = starttime
	
#update time on every frame
func _process(delta):
	time -= delta
	if time < 0:
		emit_signal("timeup",1)
	text = "%02d" % time
	
