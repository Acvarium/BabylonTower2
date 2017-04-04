extends Node2D
var mainArray = []
const BALL_SIZE = 64
var ballObj = load("res://objects/ball.tscn")
var slot = 0
var ballPressed = false
var ballPressedName = ''
var shiftPressed = Vector2(0,0)

func _fixed_process(delta):
	var mouse = get_viewport().get_mouse_pos()

	var ballPressedPos = findBallByName(ballPressedName)
	
	if ballPressed:

		var mouseOnGrid = Vector2(0,0)
		var onGrid = Vector2(0,0)

		mouseOnGrid.x = int((mouse.x - ballPressedPos.x) / 64) - 1 
		mouseOnGrid.y = int((mouse.y - 32 - ballPressedPos.y) / 64)


		onGrid.x = (int((mouse.x - ballPressedPos.x) / 64) - 1) - ballPressedPos.x
		onGrid.y = int((mouse.y - 32 - ballPressedPos.y) / 64) - ballPressedPos.y


		if onGrid.x != 0:
			var ballsToShift = []
			if ballPressedPos.y > 6:
				ballsToShift.append(get_node("balls/b" + ballPressedName))

			else:
				for i in range(6):
					var b = get_node("balls/b" + mainArray[i * 7 + ballPressedPos.y])
					ballsToShift.append(b)
			for i in range(ballsToShift.size()):

				var b = get_node("balls/b" + mainArray[mainArray.size() - 1])
				if ballPressedPos.y < 7:
					b = get_node("balls/b" + mainArray[i * 7 + ballPressedPos.y])
				var pos = b.get_pos()
				pos.x = i * 64 + mouseOnGrid.x * 64 - ballPressedPos.x * 64
				if ballPressedPos.y > 6:
					pos.x = i * 64 + mouseOnGrid.x * 64
				if pos.x > 64 * 6 - 32:
					pos.x -= 64 * 6
				elif pos.x < 0:
					pos.x += 64 * 6
				b.set_pos(pos)
			shiftPressed = Vector2(ballPressedPos.y, onGrid.x)

func _ready():
	randomize()
	set_process_input(true)
	set_fixed_process(true)
#Ключовий масив, в котрому зберігаються дані про положення кольорових кульок
	mainArray = [ 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7',
				 'o1', 'o2', 'o3', 'o4', 'o5', 'o6', 'o7',
				 'y1', 'y2', 'y3', 'y4', 'y5', 'y6', 'y7',
				 'g1', 'g2', 'g3', 'g4', 'g5', 'g6', 'g7',
				 'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7',
				 'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 
				 ''] 
#Створення кульок відповідно до ключового масиву
	shuffleBalls()
	updateBalls()
	
#Обробка подій (натискання клавіш)
func _input(event):
	if event.is_action_released("space"): 
		shuffleBalls()
		updateBalls()
	if event.is_action_released("LMB"):
		ballPressed = false

		if shiftPressed.y != 0:
			shiftRow(shiftPressed.x, shiftPressed.y)
		else:
			if findBallByName('').x == findBallByName(ballPressedName).x:

				var sCol = findBallByName(ballPressedName).x
				cutCol(findBallByName(ballPressedName))
				updateBalls()
		updateBalls()
		shiftPressed = Vector2(0,0)

#Створення однієї кульки за заданими параметрами
func createBall(name):
	var balls = get_node("balls")
	var ball = ballObj.instance()
	ball.set_name(name)
	balls.add_child(ball)
	var color = Color(0,0,0,1)
	if name != 'b':
		color = toColor(name[1])
	ball.setColor(color)
	
#Перефарбування кульок у відповідність до зазначених в ключовому масиві кольорів
func toColor(colorMark):
	var color = Color(1,1,1,1)
	if not colorMark: 			#Порожня комірка
		color = Color(0,0,0,1)
	elif colorMark == 'r':		#Червоні
		color = Color(1,0,0,1)
	elif colorMark == 'g':		#Зелені
		color = Color(0,0.6,0,1)
	elif colorMark == 'b':		#Сині
		color = Color(0,0,1,1)
	elif colorMark == 'o':		#Помаранчеві
		color = Color(1.0, 0.5, 0.0, 1.0)
	elif colorMark == 'y':		#Жовті
		color = Color(0.65, 0.65, 0.0, 1.0)
	elif colorMark == 'p':		#Фіолетові
		color = Color(0.65, 0.0, 0.65, 1.0)
	return color

#Зміщення рядка ліворуч або праворуч
func shiftRow(row, dir):
	if abs(row) == 7:
		slot += dir
		if slot < 0:
			slot = 5
		elif slot > 5:
			slot = 0
		return 0
	var tempRow = []
	for i in range(6):
		tempRow.append(mainArray[i * 7 + row])
	var tail
	if dir < 0:
		for j in range(abs(dir)):
			tail = tempRow[0]
			for i in range(tempRow.size() - 1):
				tempRow[i] = tempRow[i+1]
			tempRow[tempRow.size() - 1] = tail
	elif dir > 0:
		for j in range(abs(dir)):
			tail = tempRow[tempRow.size() - 1]
			for i in range((tempRow.size() - 1), 0 , -1):
				tempRow[i] = tempRow[i - 1]
			tempRow[0] = tail
	for i in range(6):
		mainArray[i * 7 + row] = tempRow[i]
		
func findBallByName(name):
	var index = 0
	for b in mainArray:
		if b == name:
			var col = int(index / 7)
			var row = (index - col * 7)
			if index == mainArray.size() - 1:
				return(Vector2(slot,7))
			return(Vector2(col,row))
		index += 1

#Перемішати кульки
func shuffleBalls():
	var shuffledList = [] 
	var indexList = range(mainArray.size())
	for i in range(mainArray.size()):
		var x = randi()%indexList.size()
		shuffledList.append(mainArray[indexList[x]])
		indexList.remove(x)
	mainArray = shuffledList
	slot = randi()%6

#Обновлення позицій кульок
func updateBalls():
	var index = 0
	var table = []
	for b in mainArray:
		var col = int(index / 7)
		var row = (index - col * 7)
		var name = "b" + mainArray[index]
		if not get_node("balls/" + name):
			createBall(name)
		if index < mainArray.size() - 1:
			get_node("balls" + "/b" + mainArray[index]).set_pos(Vector2(col * (BALL_SIZE), row * (BALL_SIZE)))
		else:
			get_node("balls" + "/b" + mainArray[index]).set_pos(Vector2(slot * BALL_SIZE, 7 * BALL_SIZE))	
		index += 1

#Обробка сигналів кнопок
func _signal_arrow(rowDir):
		shiftRow(abs(rowDir) - 1, sign(int(rowDir)))
		updateBalls()

func cutCol(ball):
	var column = []
	var i
	for b in range(7):
		i = b + (ball.x * 7)
		column.append(mainArray[i])
	if slot == ball.x:
		column.append(mainArray[mainArray.size() - 1])
	var empty = findBallByName('')

	var dir = 1
	if empty.y > ball.y:
		dir = -1
	i = empty.y
	while(i != ball.y):
		column[i] = column[i + dir]
		
		i += dir
	column[ball.y] = ''


	for b in range(7):
		i = b + (ball.x * 7)
		mainArray[i] = column[b]
	if slot == ball.x:
		mainArray[mainArray.size() - 1] = column[column.size() - 1]

func _signal_ballClicked(name):
	if name != 'b':
		name = name[1] + name[2]
		ballPressedName = name
	else:
		ballPressedName = ''
	ballPressed = true
