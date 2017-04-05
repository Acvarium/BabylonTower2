extends Node

func _ready():
	set_process_input(true)

func _on_easyButton_pressed():
	get_node("/root/global").gameSize = Vector2(3,4)
	get_node("/root/global").goto_scene("res://scenes/main2d.tscn")


func _on_middleBitton_pressed():
	get_node("/root/global").gameSize = Vector2(4,6)
	get_node("/root/global").goto_scene("res://scenes/main2d.tscn")


func _on_hardButton_pressed():
	get_node("/root/global").gameSize = Vector2(6,9)
	get_node("/root/global").goto_scene("res://scenes/main2d.tscn")
