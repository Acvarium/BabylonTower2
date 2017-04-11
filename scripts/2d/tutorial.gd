extends Node2D
var step = 0

func _ready():
	randomize()
	get_node("anim").play("a")
	var game = get_node("main")
	game.setGameSize(Vector2(3,4))

	game.get_node("game/hSelector").show()
	
	game.shiftRow(1, -2)
	game.cutCol(Vector2(2,1))
	game.updateBalls()

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