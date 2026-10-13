extends CharacterBody2D


@export var speed := 2
@export var width: int

var speed_multiplier = 50

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * (speed * speed_multiplier)
	else:
		velocity.x = move_toward(velocity.x, 0, (speed * speed_multiplier))

	move_and_slide()
