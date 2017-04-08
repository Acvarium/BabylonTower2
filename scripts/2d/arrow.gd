extends Node2D
export var row_dir = 0
signal arrow(row_dir)

var sprites = [
	load("res://textures/2d/arrow_norm.png"),
	load("res://textures/2d/arrow.png")]
	

func flip(f):
	get_node("Sprite").set_flip_h(f)

func _ready():
	self.connect("arrow",get_node("/root/main"),"_signal_arrow")

func set_row_dir(rd):
	row_dir = rd
	
func set_texture(t):
	get_node("Sprite").set_texture(sprites[t])
#func _on_arrow_pressed():
#	emit_signal("arrow", row_dir)
