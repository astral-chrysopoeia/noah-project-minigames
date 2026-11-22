extends StaticBody2D

class_name AsteroidLarge

var speed : float
var direction : float
var score : int
var board : AsteroidsBoard
var on_screen : bool

func _ready():
	on_screen = false
	self.hide()

func _physics_process(delta: float) -> void:
	if not board.game_active:
		return
	position += Vector2.UP.rotated(direction) * speed * delta
	if on_screen_check():
		on_screen = true
		self.show()
	if on_screen: loop_check()

func on_screen_check():
	var check = true
	if position.x > board.max_pos.x:
		check = false
	if position.x < board.min_pos.x:
		check = false
	if position.y > board.max_pos.y:
		check = false
	if position.y < board.min_pos.y:
		check = false
	return check

func loop_check():
	if position.x > board.max_pos.x:
		position.x -= board.width
	if position.x < board.min_pos.x:
		position.x += board.width
	if position.y > board.max_pos.y:
		position.y -= board.height
	if position.y < board.min_pos.y:
		position.y += board.height

func split():
	board.spawn_small_asteroids(position)
	board.update_score(score)
	await get_tree().create_timer(0.1).timeout
	self.queue_free()
