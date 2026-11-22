extends Control

class_name AsteroidsBoard

@onready var ship: AsteroidShip = $Ship
@onready var asteroids: Node2D = $Asteroids
@onready var bullets: Node2D = $Bullets
@onready var large_asteroid_scene = preload("res://Asteroids/Scenes/large_asteroid.tscn")
@onready var small_asteroid_scene = preload("res://Asteroids/Scenes/small_asteroid.tscn")
@onready var bullet_scene = preload("res://Asteroids/Scenes/bullet.tscn")

var current_score : int
var game_active : bool

@export var lives := 3
@export var max_pos := Vector2(768, 568)
@export var min_pos := Vector2(32, 32)
@export var width := 736
@export var height := 536
@export var spawn_radius := 400
@export var target_radius := 150.0
@export var asteroid_speed_range := Vector2(0.5, 1.5)
@export var missile_base_speed := 10.0
@export var asteroid_score := 100

func _ready():
	load_game()

func load_game():
	game_active = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not game_active:
		start_game()
	if event.is_action_pressed("altInteract") and game_active:
		spawn_large_asteroid()

func start_game():
	ship.start()
	game_active = true

func spawn_large_asteroid():
	var new_asteroid = large_asteroid_scene.instantiate()
	asteroids.add_child(new_asteroid)
	new_asteroid.board = self
	var spawnpoint = Vector2(0, 1 * spawn_radius).rotated(deg_to_rad(randf_range(0.0, 360.0)))
	spawnpoint += Vector2(400, 300)
	new_asteroid.position = spawnpoint
	var target = Vector2(0, -1 * randf_range(0.0, target_radius)).rotated(deg_to_rad(randf_range(0.0, 360.0)))
	target += Vector2(400, 300)
	var angle = spawnpoint.angle_to_point(target) - deg_to_rad(90)
	new_asteroid.rotation = angle
	new_asteroid.direction = angle
	new_asteroid.speed = randf_range(asteroid_speed_range[0], asteroid_speed_range[1])

func spawn_small_asteroids(pos: Vector2):
	for i in range(4):
		var new_asteroid = small_asteroid_scene.instantiate()
		asteroids.add_child.call_deferred(new_asteroid)
		new_asteroid.board = self
		new_asteroid.position = pos
		var angle = randf_range(0.0, 360.0)
		new_asteroid.rotation = angle
		new_asteroid.direction = angle
		new_asteroid.speed = randf_range(asteroid_speed_range[0], asteroid_speed_range[1])

func spawn_missile():
	var missile = bullet_scene.instantiate()
	bullets.add_child(missile)
	missile.board = self
	missile.position = ship.position + Vector2(0, -12).rotated(ship.direction)
	missile.rotation = ship.direction
	missile.direction = ship.direction
	missile.speed = missile_base_speed + ship.current_speed

func update_score(score: int):
	current_score += score
