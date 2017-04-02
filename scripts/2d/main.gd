extends Node2D
var mainArray = []
const BALL_SIZE = 64
var ballObj = load("res://objects/ball.tscn")
var slot = 0


func _ready():
	randomize()
	set_process_input(true)
#Ключовий масив, в котрому зберігаються дані про положення кольорових кульок
	mainArray = [ 'r1', 'r2', 'r3', 'r4', 'r5', 'r6', 'r7',
				 'o1', 'o2', 'o3', 'o4', 'o5', 'o6', 'o7',
				 'y1', 'y2', 'y3', 'y4', 'y5', 'y6', 'y7',
				 'g1', 'g2', 'g3', 'g4', 'g5', 'g6', 'g7',
				 'b1', 'b2', 'b3', 'b4', 'b5', 'b6', 'b7',
				 'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 
				 ''] 
#Створення кульок відповідно до ключового масиву
	updateBalls()

#Обробка подій (натискання клавіш)
func _input(event):
	if event.is_action_released("space"): 
		shuffleBalls()
		updateBalls()

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
		color = Color(0,1,0,1)
	elif colorMark == 'b':		#Сині
		color = Color(0,0,1,1)
	elif colorMark == 'o':		#Помаранчеві
		color = Color(1.0, 0.5, 0.0, 1.0)
	elif colorMark == 'y':		#Жовті
		color = Color(0.65, 0.65, 0.0, 1.0)
	elif colorMark == 'p':		#Фіолетові
		color = Color(1.0, 0.0, 1.0, 1.0)
	return color

#Зміщення рядка ліворуч або праворуч
func shiftRow(rowDir):
	var tempRow = []
	for i in range(6):
		tempRow.append(mainArray[i * 7 + abs(rowDir) - 1] )
	var tail
	if rowDir < 0:
		tail = tempRow[0]
		for i in range((tempRow.size() - 1)):
			tempRow[i] = tempRow[i+1]
		tempRow[tempRow.size() - 1] = tail
	elif rowDir > 0:
		tail = tempRow[tempRow.size() - 1]
		for i in range((tempRow.size() - 1), 0, -1):
			tempRow[i] = tempRow[i-1]
		tempRow[0] = tail

	for i in range(6):
		mainArray[i * 7  + abs(rowDir) - 1] = tempRow[i]

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
		if abs(rowDir) == 8:
			slot += sign(float(rowDir))
			if slot < 0:
				slot = 5
			elif slot > 5:
				slot = 0
		else:
			shiftRow(rowDir)
		updateBalls()

func _signal_ballClicked(name):
	
	if name != 'b':
		name = name[1] + name[2]
		if findBallByName('').x == findBallByName(name).x:
			print(findBallByName(name))
		
