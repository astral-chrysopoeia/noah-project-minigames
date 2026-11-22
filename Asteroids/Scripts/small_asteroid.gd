extends StaticBody2D

class_name AsteroidSmall

var speed : float
var direction : float
var score : int
var board : AsteroidsBoard

func _physics_process(delta: float) -> void:
	if not board.game_active:
		return
	position += Vector2.UP.rotated(direction) * speed * delta
	loop_check()

func loop_check():
	if position.x > board.max_pos.x:
		position.x -= board.width
	if position.x < board.min_pos.x:
		position.x += board.width
	if position.y > board.max_pos.y:
		position.y -= board.height
	if position.y < board.min_pos.y:
		position.y += board.height

func destroy():
	board.update_score(score)
	self.queue_free()
