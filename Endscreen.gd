extends Control
var dict = {}
func _ready():
	var file = FileAccess.open("res://Scores.tres", FileAccess.READ)
	dict = JSON.parse_string(file.get_as_text())
	print(file.get_as_text())
