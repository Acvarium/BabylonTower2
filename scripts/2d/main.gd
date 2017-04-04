extends Node2D
var mainArray = []
const BALL_SIZE = 64
var ballObj = load("res://objects/ball.tscn")
var ballPressed = false
var ballPressedName = ''
var shiftPressed = Vector2(0,0)

const MAX_SIZE = Vector2(6,9)
var gameSize = Vector2(2,2)

const COLORS_NAMES = ['r', 'g', 'b', 'o', 'y', 'p']
const COLORS = {
'black' : Color(1,1,1,1),						#Чорний					0
'empty' : Color(0,0,0,0),						#Порожня комірка		1
"red" : Color(1,0,0,1),							#Червоний				2
"green" : Color(0,0.6,0,1),						#Зелені					3
"blue" : Color(0,0,1,1),						#Сині					4
"orange" : Color(1.0, 0.5, 0.0, 1.0),			#Помаранчеві			5
"yellow" : Color(0.65, 0.65, 0.0, 1.0),			#Жовті					6
"purple" : Color(0.65, 0.0, 0.65, 1.0),			#Фіолетові				7
}

func setGameSize(size):
	if size.x <= MAX_SIZE.x and size.y <= MAX_SIZE.y and size.x > 1 and size.y > 1:
		for b in get_node("game/balls").get_children():
			b.free()
		
		gameSize = size
		generateMainArray()
		updateBalls()
#		if gameSize.y > gameSize.x:
#			get_node("game").set_scale(Vector2(6 / (gameSize.y), 6 / (gameSize.y)))
#		else:
		get_node("game").set_scale(Vector2(8 / (gameSize.x + 2), 8 / (gameSize.x + 2)))


func generateMainArray():
	mainArray = []
	print(gameSize)
	for i in range(gameSize.x):
		for j in range(gameSize.y):
			mainArray.append(str(COLORS_NAMES[i] + str(j)))
	mainArray[mainArray.size() - 1] = ''

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

			for i in range(gameSize.x):
				var b = get_node("game/balls/b" + mainArray[i * gameSize.y + ballPressedPos.y])
				ballsToShift.append(b)
			for i in range(ballsToShift.size()):

				var b = get_node("game/balls/b" + mainArray[mainArray.size() - 1])
				if ballPressedPos.y < gameSize.y:
					b = get_node("game/balls/b" + mainArray[i * gameSize.y + ballPressedPos.y])
				var pos = b.get_pos()
				pos.x = i * 64 + mouseOnGrid.x * 64 - ballPressedPos.x * 64

				if pos.x > 64 * gameSize.x - 32:
					pos.x -= 64 * gameSize.x
				elif pos.x < 0:
					pos.x += 64 * gameSize.x
				b.set_pos(pos)
			shiftPressed = Vector2(ballPressedPos.y, onGrid.x)

func _ready():
	randomize()
	set_process_input(true)
	set_fixed_process(true)
	
	setGameSize(get_node("/root/global").gameSize)
#	generateMainArray()
	shuffleBalls()
	updateBalls()
	
#Обробка подій (натискання клавіш)
func _input(event):
	if event.is_action_released("space"): 
		shuffleBalls()
		updateBalls()
		ballPressed = false
	
	if event.is_action_released("ui_right"): 
		setGameSize(Vector2(gameSize.x + 1, gameSize.y))
	if event.is_action_released("ui_left"): 
		setGameSize(Vector2(gameSize.x - 1, gameSize.y))
		
	if event.is_action_released("ui_down"): 
		setGameSize(Vector2(gameSize.x, gameSize.y + 1))
	if event.is_action_released("ui_up"): 
		setGameSize(Vector2(gameSize.x, gameSize.y - 1))

		
	if event.is_action_released("LMB"):
		if shiftPressed.y != 0:
			shiftRow(shiftPressed.x, shiftPressed.y)
		else:
			if findBallByName('').x == findBallByName(ballPressedName).x and ballPressed:
				var sCol = findBallByName(ballPressedName).x
				cutCol(findBallByName(ballPressedName))
				updateBalls()
		ballPressed = false
		updateBalls()
		shiftPressed = Vector2(0,0)

#Створення однієї кульки за заданими параметрами
func createBall(name):
	var balls = get_node("game/balls")
	var ball = ballObj.instance()
	ball.set_name(name)
	balls.add_child(ball)
	var color = Color(0,0,0,1)
	if name != 'b':
		color = toColor(name[1])
	ball.setColor(color)
	
#Перефарбування кульок у відповідність до зазначених в ключовому масиві кольорів
func toColor(colorMark):
	var color = COLORS['black']
	if not colorMark: 			#Порожня комірка
		color = COLORS['empty']
	elif colorMark == 'r':		#Червоні
		color = COLORS['red']
	elif colorMark == 'g':		#Зелені
		color = COLORS['green']
	elif colorMark == 'b':		#Сині
		color = COLORS['blue']
	elif colorMark == 'o':		#Помаранчеві
		color = COLORS['orange']
	elif colorMark == 'y':		#Жовті
		color = COLORS['yellow']
	elif colorMark == 'p':		#Фіолетові
		color = COLORS['purple']
	return color

#Зміщення рядка ліворуч або праворуч
func shiftRow(row, dir):
	var tempRow = []
	for i in range(gameSize.x):
		tempRow.append(mainArray[i * gameSize.y + row])
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
	for i in range(gameSize.x):
		mainArray[i * gameSize.y + row] = tempRow[i]
		
func findBallByName(name):
	var index = 0
	for b in mainArray:
		if b == name:
			var col = int(index / gameSize.y)
			var row = (index - col * gameSize.y)
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


#Обновлення позицій кульок
func updateBalls():
	var index = 0
	var table = []
	for b in mainArray:
		var col = int(index / gameSize.y)
		var row = (index - col * gameSize.y)
		var name = "b" + mainArray[index]
		if not get_node("game/balls/" + name):
			createBall(name)
		get_node("game/balls/b" + mainArray[index]).set_pos(Vector2(col * (BALL_SIZE), row * (BALL_SIZE)))
		index += 1

#Обробка сигналів кнопок
func _signal_arrow(rowDir):
	shiftRow(abs(rowDir) - 1, sign(int(rowDir)))
	updateBalls()

func cutCol(ball):
	var column = []
	var i
	for b in range(gameSize.y):
		i = b + (ball.x * gameSize.y)
		column.append(mainArray[i])
	var empty = findBallByName('')

	var dir = 1
	if empty.y > ball.y:
		dir = -1
	i = empty.y
	while(i != ball.y):
		column[i] = column[i + dir]
		
		i += dir
	column[ball.y] = ''
	for b in range(gameSize.y):
		i = b + (ball.x * gameSize.y)
		mainArray[i] = column[b]

func _signal_ballClicked(name):
	if name != 'b':
		name = name[1] + name[2]
		ballPressedName = name
	else:
		ballPressedName = ''
	ballPressed = true
