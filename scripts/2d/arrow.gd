extends TextureButton
export var mov = 0
signal arrow(mov)

func _ready():
#	print(str("______" + get_node("/root/main").get_name()))
	self.connect("arrow",get_node("/root/main"),"_signal_arrow")

func _on_arrow_pressed():
	emit_signal("arrow", mov)
