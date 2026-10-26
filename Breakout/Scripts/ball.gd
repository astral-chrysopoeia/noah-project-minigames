extends CharacterBody2D

class_name BreakoutBall

@export var starting_speed : float
@export var starting_launch_angle := 45.0
@export var maxBounceAngle := 60.0
@export var board : BreakoutBoard

var moving : bool
var current_speed : float
var direction_angle : float
var direction_vector : Vector2

func _ready() -> void:
	start()

func start():
	moving = false
	position = Vector2(0, 285)
	current_speed = starting_speed
	direction_angle = starting_launch_angle
	direction_vector = Vector2.UP.rotated(deg_to_rad(direction_angle))

func launch():
	moving = true

func _physics_process(delta: float) -> void:
	if not moving:
		return
	if board.bricks.get_child_count() == 0:
		board.next_level()
	var collision_info = move_and_collide(direction_vector * current_speed * delta)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider is BreakoutPaddle:
			direction_vector = calculate_paddle_bounce(collision_info, collider)
		else:
			if collider is BreakoutBrick:
				collider.hit()
				board.update_score(0)
			direction_vector = direction_vector.bounce(collision_info.get_normal())

func calculate_paddle_bounce(collision: KinematicCollision2D, paddle: Node2D) -> Vector2:
	var paddleWidth = paddle.width
	var collisionPoint = collision.get_position().x
	var paddleCenter = paddle.position.x
	
	var hitOffset = (collisionPoint - paddleCenter) / (paddleWidth / 2)
	hitOffset = clampf(hitOffset, -1, 1)
	
	var bounceAngleRad = deg_to_rad(maxBounceAngle) * hitOffset
	
	var newDirection = Vector2(tan(bounceAngleRad), -1).normalized()
	return newDirection
