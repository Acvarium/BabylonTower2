extends Node2D
var step = 0

func _ready():
	randomize()
	get_node("anim").play("a")
	var game = get_node("main")
	game.cControl = true
	game.setGameSize(Vector2(3,4))
	
	set_fixed_process(true)
#	game.get_node("game/hSelector").show()
	
	game.shiftRow(1, -2)
	game.cutCol(Vector2(2,1))
	game.updateBalls()

func _fixed_process(delta):
	var sp = get_node("Sprite")
	var game = get_node("main")
#	sp.set_pos(get_local_mouse_pos())
#	game.cursor_position = sp.get_pos()
	
#	print( sp.get_texture().get_name() )
	if sp.get_texture().get_name() == 'finger_down.png':
		game.ball_clicked(sp.get_pos())
	else:
		game.ballPressed = false
	

func _on_Timer_timeout():
	var game = get_node("main")
	if step == 0:
		game.get_node("game/hSelector").hide()
		game.shiftRow(1, -2)
		game.updateBalls()
		get_node("Timer").set_wait_time(1)
	elif step == 1:
		game.cutCol(Vector2(0,2))
		game.updateBalls()
		
		
#	else:
#		var a = game.findBallByName('')
#		game.cutCol(Vector2(randi()%4,a.y))
#		game.shiftRow(randi()%4, randi()%2 - 2)
#		game.updateBalls()
	step += 1