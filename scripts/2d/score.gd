extends Node2D

var steps = 0
var time = 0

func set_steps(s):
	steps = s
	get_node("steps").set_text(str(steps))
	
func set_time(t):
	time = t
	get_node("time").set_text(str(time))

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
