extends Node

func _ready():
	set_process_input(true)
	fit_to_screen()


func fit_to_screen():
	var game_screen_size = get_node("/root/global").screen_size
	var screen_resolution = get_viewport().get_rect().size
	var game_ratio = game_screen_size.y / game_screen_size.x
	var ratio = screen_resolution.y / screen_resolution.x
	var bg = get_node("bg")
	var scale = bg.get_scale()
	scale.y = scale.y * (ratio / game_ratio)
	bg.set_scale(scale)


func _on_easyButton_pressed():
	get_node("/root/global").gameSize = Vector2(3,6)
	get_node("/root/global").game_mode = 1
	
	get_node("/root/global").goto_scene("res://scenes/main2d.tscn")

func _on_middleBitton_pressed():
	get_node("/root/global").gameSize = Vector2(4,7)
	get_node("/root/global").game_mode = 1
	get_node("/root/global").goto_scene("res://scenes/main2d.tscn")

func _on_hardButton_pressed():
	get_node("/root/global").gameSize = Vector2(6,10)
	get_node("/root/global").game_mode = 2
	get_node("/root/global").goto_scene("res://scenes/main2d.tscn")


func _on_hardButton1_pressed():
	get_node("/root/global").gameSize = Vector2(6,10)
	get_node("/root/global").game_mode = 2
	get_node("/root/global").goto_scene("res://scenes/tutorial.tscn")
