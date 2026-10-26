extends StaticBody2D

class_name BreakoutBrick

var score:= 100
var board : BreakoutBoard
var health : int
@onready var color: ColorRect = $ColorRect

func _ready() -> void:
	pass

func hit():
	health -= 1
	if health <= 0:
		break_brick()
	else:
		var points = score / 2
		board.update_score(points)
		update_color()

func update_color():
	match(health):
		1:
			color.color = Color.RED
		2:
			color.color = Color.ORANGE
		3:
			color.color = Color.YELLOW
		4:
			color.color = Color.GREEN
		5:
			color.color = Color.BLUE

func break_brick():
	var points = score
	board.update_score(points)
	# Dusty, put code here to boost sanity when breaking a brick
	self.queue_free()
