extends Area2D

class_name AsteroidsBullet

var speed := 1.0
var direction : float
var lifespan := 5.0
var time_since_spawn := 0.0
var board : AsteroidsBoard

func _ready():
	time_since_spawn = 0.0

func _physics_process(delta: float) -> void:
	if not board.game_active:
		return
	position += Vector2.UP.rotated(direction) * speed * delta
	loop_check()
	time_since_spawn += delta
	if time_since_spawn >= lifespan:
		despawn()

func loop_check():
	if position.x > board.max_pos.x:
		position.x -= board.width
	if position.x < board.min_pos.x:
		position.x += board.width
	if position.y > board.max_pos.y:
		position.y -= board.height
	if position.y < board.min_pos.y:
		position.y += board.height

func despawn():
	self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is AsteroidLarge:
		body.split()
		despawn()
	elif body is AsteroidSmall:
		body.destroy()
		despawn()
