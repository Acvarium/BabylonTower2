extends Node2D
export var row_dir = 0
signal arrow(row_dir)

func flip(f):
	get_node("Sprite").set_flip_h(f)

func _ready():
#	print(str("______" + get_node("/root/main").get_name()))
	self.connect("arrow",get_node("/root/main"),"_signal_arrow")

func set_row_dir(rd):
	row_dir = rd
	

#func _on_arrow_pressed():
#	emit_signal("arrow", row_dir)
