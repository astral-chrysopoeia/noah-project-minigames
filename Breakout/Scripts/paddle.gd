extends StaticBody2D

class_name BreakoutPaddle

@export var starting_speed := 2.0
@export var width: int
@export var board : BreakoutBoard

var current_speed: float

func start():
	position.x = 0
	current_speed = starting_speed

func _physics_process(delta: float) -> void:
	if not board.game_active:
		return
	var direction := Input.get_axis("left", "right")
	direction += Input.get_axis("navLeft", "navRight")
	direction = clampf(direction, -1, 1)
	position.x = clampf(position.x + (direction * current_speed * delta), -196, 196)
