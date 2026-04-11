extends CharacterBody2D


@export var speed := 10000.0
@onready var spit_ball_scene := preload("res://scenes/spit_ball.tscn")

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var _directionx := Input.get_axis("move_left", "move_right")
	var _directiony := Input.get_axis("move_up", "move_down")
	if _directionx:
		velocity.x = _directionx * speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	if _directiony:
		velocity.y = _directiony * speed * delta
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
	
	if Input.is_action_pressed("shoot"):
		spawn_projectile()
	
	move_and_slide()

func spawn_projectile():
	var spit_ball := spit_ball_scene.instantiate()
	spit_ball.velocity = Vector2(0, 100)
