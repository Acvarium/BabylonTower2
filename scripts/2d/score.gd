extends Node2D
var steps = 0
var time = 0


func fit_to_screen():
	var game_screen_size = get_node("/root/global").screen_size
	var screen_resolution = get_viewport().get_rect().size
	var game_ratio = game_screen_size.y / game_screen_size.x
	var ratio = screen_resolution.y / screen_resolution.x
	var bg = get_node("bg")
	var scale = bg.get_scale()
	scale.y = scale.y * (ratio / game_ratio)
	bg.set_scale(scale)
	var bottom_pos = get_node("bottom").get_pos()
	bottom_pos.y = game_screen_size.y * (ratio / game_ratio)
	get_node("bottom").set_pos(bottom_pos)

func set_steps(s):
	steps = s
	get_node("steps").set_text(str(steps))
	
func set_time(t):
	time = t
	var minutes = int(time / 60)
	var sec = int(time - (minutes * 60))
	get_node("time").set_text(str("%02d" % minutes) + ":" + str("%02d" % sec))

func _ready():
	fit_to_screen()
	set_steps(get_node("/root/global").steps)
	set_time(get_node("/root/global").time)


func _on_TextureButton_pressed():
	get_node("/root/global").goto_scene("res://scenes/startMenu.tscn")


