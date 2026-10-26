extends Control

class_name BreakoutBoard

@onready var bricks: Node2D = $Bricks
@onready var brick_scene = preload("res://Breakout/Scenes/brick.tscn")
@onready var ball: Node2D = $Ball
@onready var paddle: BreakoutPaddle = $Paddle
@onready var current_score_label: Label = $Screen/HUD/CurrentScore
@onready var best_score_label: Label = $Screen/HUD/BestScore
@onready var life_display: Control = $Screen/HUD/Lives
@onready var life_sprite_scene = preload("res://Breakout/Scenes/life_sprite.tscn")
@onready var game_over_screen: Control = $GameOverScreen
@onready var win_text: Label = $GameOverScreen/WinText
@onready var game_over_text: Label = $GameOverScreen/GameOverText

var score: int
var game_active : bool
var current_score : int
var level : int
var current_lives : int
var dead : bool
var end : bool
var score_since_oneup: int

@export var starting_lives := 3
@export var brick_rows := 5
@export var base_points := 100
@export var oneup_score := 10000
@export var end_level := 8
@export var max_lives := 10

func _ready() -> void:
	load_game()

func load_game():
	game_over_screen.hide()
	score = 0
	level = 1
	current_lives = starting_lives
	spawn_bricks(brick_rows)
	spawn_ball()
	paddle.start()
	current_score = 0
	score_since_oneup = 0
	game_active = false
	end = false
	update_score_display()
	update_lives_display()

func start_game():
	game_active = true
	ball.launch()

func play_again():
	for brick in bricks.get_children():
		brick.queue_free()
	load_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not game_active and not dead:
		start_game()
	elif event.is_action_pressed("interact") and not game_active and dead and end:
		play_again()

func spawn_bricks(rows):
	var y_pos = -280
	var row = rows
	for i in range(rows):
		var x_pos = -242
		for j in range(12):
			spawn_brick(x_pos, y_pos, row, level)
			x_pos += 44
		row -= 1
		y_pos += 20

func spawn_brick(x, y, row, current_level):
	var new_brick = brick_scene.instantiate()
	bricks.add_child(new_brick)
	new_brick.position = Vector2(x, y)
	new_brick.health = get_health(row, current_level)
	new_brick.update_color()
	new_brick.board = self

func get_health(row, current_level):
	var health = row + (current_level - 1) - 4
	health = clampi(health, 1, 5)
	return health

func _on_bottom_wall_body_entered(body: Node2D) -> void:
	if body is BreakoutBall:
		current_lives -= 1
		update_lives_display()
		ball.moving = false
		game_active = false
		dead = true
		await get_tree().create_timer(.5).timeout
		if current_lives <= 0:
			game_over(false)
		else:
			spawn_ball()
			paddle.position.x = 0

func next_level():
	level += 1
	ball.moving = false
	game_active = false
	await get_tree().create_timer(.5).timeout
	# Dusty, put code here to boost sanity when reaching the next level
	if level > end_level:
		game_over(true)
	paddle.position.x = 0
	spawn_bricks(brick_rows)
	spawn_ball()
	update_score_display()
	update_lives_display()

func spawn_ball():
	dead = false
	ball.start()

func update_score(points):
	current_score += points
	score_since_oneup += points
	if score_since_oneup >= oneup_score:
		oneup()
	ball.current_speed = clampf(ball.starting_speed + (current_score / 50.0), ball.starting_speed, 2 * ball.starting_speed)
	paddle.current_speed = clampf(paddle.starting_speed + (current_score / 100.0), paddle.starting_speed, 2 * paddle.starting_speed)
	update_score_display()

func update_score_display():
	current_score_label.text = "Score: " + str(current_score)
	best_score_label.text = "Best: " + str(BestScores.breakout_highscore)

func update_lives_display():
	var last_lives_update = life_display.get_child_count()
	if current_lives == last_lives_update:
		return
	elif current_lives > last_lives_update:
		while current_lives > life_display.get_child_count():
			var new_life = life_sprite_scene.instantiate()
			life_display.add_child(new_life)
			new_life.position.y = 16
			new_life.position.x = life_display.get_child_count() * 48 - 16
	else:
		while current_lives < life_display.get_child_count():
			var last_index = life_display.get_child_count() - 1
			var last_child = life_display.get_child(last_index)
			last_child.queue_free()
			await get_tree().create_timer(.1).timeout

func oneup():
	current_lives = clampi(current_lives + 1, 0, max_lives)
	score_since_oneup -= oneup_score
	update_lives_display()

func game_over(win: bool):
	end = true
	game_over_screen.show()
	if current_score > BestScores.breakout_highscore:
		BestScores.breakout_highscore = current_score
		# Dusty, put code here to boost sanity when setting a high score
	update_score_display()
	if win:
		win_text.show()
		game_over_text.hide()
	else:
		win_text.hide()
		game_over_text.show()
