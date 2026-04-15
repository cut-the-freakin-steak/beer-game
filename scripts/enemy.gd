extends CharacterBody2D
class_name Enemy

@export var speed: float = 1900.0
@export var ranged: bool = false
@export var damage: int = 20
@export var health: int = 5
@export var cooldown: float = 1
@onready var player: CharacterBody2D = $"../Player"
@onready var player_hurtbox: Area2D = $"../Player/HurtBox"
@onready var player_health: ProgressBar = $"../Player/HUD/HealthBar"
@onready var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
@onready var bullet_spawner: Marker2D = $Anchor/Gun/BulletSpawner
@onready var zombie_animations: AnimatedSprite2D = $"../Zombie/AnimatedSprite2D"
var can_shoot = true
var screen_size
var wanted_distance = 90

func _ready() -> void:
	add_to_group("enemy")

func _process(delta: float) -> void:
	screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _physics_process(delta: float) -> void:
	if ranged == false:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed * delta
	else:
		var dis = global_position.distance_to(player.global_position)
		var direction = global_position.direction_to(player.global_position)
		if dis > wanted_distance + 10:
			velocity = direction * speed * delta
		elif dis < wanted_distance + 10:
			velocity = -direction * speed * delta
		else:
			velocity = Vector2.ZERO
		var player_position = $"../Player".global_position
		var angle := global_position.angle_to_point(player_position)
		$Anchor.rotation = angle
		if $PlayerRange.overlaps_area(player_hurtbox) and can_shoot == true:
			spawn_bullet()
			can_shoot = false
			await get_tree().create_timer(cooldown).timeout
			can_shoot = true

	move_and_slide()
	if is_instance_valid($"../Zombie"):
		if velocity.x > 5:
			zombie_animations.flip_h = false
			zombie_animations.play("Walking")
		elif velocity.x < -5:
			zombie_animations.flip_h = true
			zombie_animations.play("Walking")
		if velocity.y < -5:
			zombie_animations.play("Up")
		elif velocity.y > 5:
			zombie_animations.play("Down")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == player_hurtbox:
		$"../Player/HurtSound".pitch_scale = randf_range(0.9, 1.1)
		$"../Player/HurtSound".play()
		player_health.value -= damage

func spawn_bullet() -> void:
	var direction = global_position.direction_to(player.global_position)
	var bullet: CharacterBody2D = bullet_scene.instantiate()
	$Bullets.add_child(bullet)
	bullet.global_position = bullet_spawner.global_position
	bullet.velocity = bullet.speed * direction
