extends Node2D
var steps = 0
var time = 0

func set_steps(s):
	steps = s
	get_node("steps").set_text(str(steps))
	
func set_time(t):
	time = t
	var minutes = int(time / 60)
	var sec = int(time - (minutes * 60))
	get_node("time").set_text(str("%02d" % minutes) + ":" + str("%02d" % sec))

func _ready():
	set_steps(get_node("/root/global").steps)
	set_time(get_node("/root/global").time)


func _on_TextureButton_pressed():
	get_node("/root/global").goto_scene("res://scenes/startMenu.tscn")


