extends Node2D

@onready var bricks: Node2D = $Bricks

var score: int

@export var lives = 3

func _ready() -> void:
	score = 0
