extends Area2D

class_name AsteroidShip

@export var shot_cooldown := 1.0
@export var acceleration := 1.0
@export var rotation_speed := 1.0
@export var max_speed := 5.0
@export var board : AsteroidsBoard

var time_since_shot : float
var can_shoot : bool
var current_speed : float
var direction : float

func _ready():
	spawn()

func spawn():
	rotation = 0
	direction = rotation
	position = Vector2(400, 300)
	current_speed = 0

func start():
	time_since_shot = 0.0
	can_shoot = true

func _physics_process(delta: float) -> void:
	if not board.game_active:
		return
	if not can_shoot:
		time_since_shot += delta
		if time_since_shot >= shot_cooldown:
			can_shoot = true
	var rotation_direction = Input.get_axis("left", "right")
	rotation_direction += Input.get_axis("navLeft", "navRight")
	rotation_direction = clampf(rotation_direction, -1, 1)
	rotation_degrees += rotation_direction * delta * rotation_speed
	direction = rotation
	var acceleration_direction = Input.get_axis("forward", "back")
	acceleration_direction += Input.get_axis("navUp", "navDown")
	acceleration_direction = -1 * clampf(acceleration_direction, -1, 1)
	current_speed += acceleration_direction * acceleration * delta
	current_speed = clampf(current_speed, 0, max_speed)
	position += Vector2.UP.rotated(direction) * current_speed * delta
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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_shoot:
		shoot()

func shoot():
	can_shoot = false
	time_since_shot = 0.0
	board.spawn_missile()

func crash():
	board.game_active = false

func _on_body_entered(body: Node2D) -> void:
	if body is AsteroidLarge or body is AsteroidSmall:
		crash()
