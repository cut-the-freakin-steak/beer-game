extends CharacterBody2D

@export var speed := 10000.0
var screen_size
var roll_direction = Vector2.ZERO

func _process(delta: float) -> void:
	screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	if $HUD/HealthBar.value == 0:
		get_tree().paused = true

func _physics_process(delta: float) -> void:
	if velocity.is_zero_approx():
		$AnimatedSprite2D.play("idle")
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var _direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if _direction:
		velocity = _direction.normalized() * speed * delta
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			$AnimatedSprite2D.play("walking")
		elif Input.is_action_pressed("move_up"):
			$AnimatedSprite2D.play("walk_up")
		elif Input.is_action_pressed("move_down"):
			$AnimatedSprite2D.play("walk_down")
	else:
		velocity = Vector2.ZERO

	if Input.is_action_just_pressed("roll"):
		roll_direction = velocity.normalized()
		velocity = 3 * (roll_direction * speed * delta)

	move_and_slide()
