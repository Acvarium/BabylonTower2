extends Node2D
var mainArray = []
const BALL_SIZE = 64
var ballObj = load("res://objects/ball.tscn")
var slot = 0

func _ready():
	randomize()
	set_process_input(true)
	mainArray = [ 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7',
				 'o1', 'o2', 'o3', 'o4', 'o5', 'o6', 'o7',
				 'y1', 'y2', 'y3', 'y4', 'y5', 'y6', 'y7',
				 'g1', 'g2', 'g3', 'g4', 'g5', 'g6', 'g7',
				 'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7',
				 'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 
				 ''] 
	createBalls()
#	shuffleBalls()
#	updateBallsPos()

func _input(event):
	if event.is_action_released("space"):
		shuffleBalls()
#		relocateRow(1)
		updateBallsPos()


func createBalls():
	for row in range(8):
		var s = ''
		if row < 7:
			for col in range(6):
				var n = (col*7)+row
				s = s + mainArray[n] + " "
				var balls = get_node("balls")
				var ball = ballObj.instance()
				var name = ('b' + mainArray[n])
				ball.set_name(name)
				print(ball.get_name())
				balls.add_child(ball)
				ball.set_pos(Vector2(col * (BALL_SIZE), row * (BALL_SIZE))) 
				var color = Color(1,1,1,1)
				if not mainArray[n]:
					color = Color(0,0,0,1)
				elif mainArray[n][0] == 'r':
					color = Color(1,0,0,1)
				elif mainArray[n][0] == 'g':
					color = Color(0,1,0,1)
				elif mainArray[n][0] == 'b':
					color = Color(0,0,1,1)
				elif mainArray[n][0] == 'o':
					color = Color(1.0, 0.5, 0.0, 1.0)
				elif mainArray[n][0] == 'y':
					color = Color(1.0, 1.0, 0.003035, 1.0)
				elif mainArray[n][0] == 'p':
					color = Color(1.0, 0.003035, 1.0, 1.0)
				ball.setColor(color)
			print(s)
		else:
			var ball = ballObj.instance()
			ball.set_name('b')
			get_node("balls").add_child(ball)
			ball.set_pos(Vector2(0, (7 *BALL_SIZE)))
			var color = Color(0,0,0,1)
			ball.setColor(color)

func shuffleBalls():
	mainArray = shuffleList(mainArray) 

func relocateRow(row):
	
	var tempRow = []
	for i in range(6):
		tempRow.append(mainArray[i * 7 + abs(row) - 1] )
	var tail
	if row < 0:
		tail = tempRow[0]
		for i in range((tempRow.size() - 1)):
			tempRow[i] = tempRow[i+1]
		tempRow[tempRow.size() - 1] = tail
	elif row > 0:
		tail = tempRow[tempRow.size() - 1]
		for i in range((tempRow.size() - 1), 0, -1):
			tempRow[i] = tempRow[i-1]
		tempRow[0] = tail

	for i in range(6):
		mainArray[i * 7  + abs(row) - 1] = tempRow[i]


func shuffleList(list):
	var shuffledList = [] 
	var indexList = range(list.size())
	for i in range(list.size()):
		var x = randi()%indexList.size()
		shuffledList.append(list[indexList[x]])
		indexList.remove(x)
	return shuffledList

func updateBallsPos():
	var index = 0
	var table = []
	for b in mainArray:
		var col = int(index / 7)
		var row = (index - col * 7)
		table.append(str(str(col) + str(row) + ' '))
		if index < mainArray.size() - 1:
			get_node("balls" + "/b" + mainArray[index]).set_pos(Vector2(col * (BALL_SIZE), row * (BALL_SIZE)))			
		else:
			get_node("balls" + "/b" + mainArray[index]).set_pos(Vector2(0, 7 * (BALL_SIZE)))	
		index += 1
	print(table)
#	
#	for row in range(8):
#		if row < 7:
#			for col in range(6):
#				var n = (col*7)+row
#				var name = ('b' + mainArray[n])
#				var ball = get_node("balls" + "/" + name)
#				ball.set_pos(Vector2(col * (BALL_SIZE), row * (BALL_SIZE))) 

#		else:
#			var name = ('b' + mainArray[(8)+row])
#			var ball = get_node("balls" + "/" + name)
#			ball.set_pos(Vector2(slot * BALL_SIZE, row * BALL_SIZE)) 

				

func _signal_arrow(mov):
		relocateRow(mov)
		updateBallsPos()
