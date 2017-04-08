extends KinematicBody2D

signal ballClicked(name)

func _ready():
	self.connect("ballClicked",get_node("/root/main"),"_signal_ballClicked")

	
func setColor(color):
	get_node("Sprite").set_modulate(color)
	if color.a == 0:
		get_node("shadow").hide()


func _on_TextureButton_button_down():
	var name = get_name()
	emit_signal("ballClicked", name)
