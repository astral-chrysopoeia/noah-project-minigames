extends Control

@onready var bricks: Node2D = $Bricks
@onready var brick_scene = preload("res://Breakout/Scenes/brick.tscn")

var score: int

@export var lives = 3
@export var brick_rows = 5
@export var base_points = 100

func _ready() -> void:
	score = 0
	spawn_bricks(brick_rows)

func spawn_bricks(rows):
	var y_pos = -300
	var score_modifier = rows
	for i in range(rows):
		var x_pos = -242
		for j in range(12):
			spawn_brick(x_pos, y_pos, score_modifier)
			x_pos += 44
		score_modifier -= 1
		y_pos += 20

func spawn_brick(x, y, score_modifier):
	var new_brick = brick_scene.instantiate()
	bricks.add_child(new_brick)
	new_brick.position = Vector2(x, y)
	new_brick.score = score_modifier * base_points
