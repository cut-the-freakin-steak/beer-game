extends CharacterBody2D
class_name Enemy

@export var speed: float = 1900.0
@export var ranged: bool = false
@export var damage: int = 20
@export var health: int = 5
@export var cooldown: float = 1
@onready var Player: CharacterBody2D = $"../Player"
@onready var PlayerHurtbox: Area2D = $"../Player/HurtBox"
@onready var PlayerHealth: ProgressBar = $"../Player/HUD/HealthBar"
@onready var bullet_scene: PackedScene = preload("res://scenes/bullet.tscn")
@onready var BulletSpawner: Marker2D = $Anchor/Gun/BulletSpawner
@onready var ZombieAnimations: AnimatedSprite2D = $"../Zombie/AnimatedSprite2D"
var can_shoot = true
var screen_size
var wanted_distance = 90

func _process(delta: float) -> void:
	screen_size = get_viewport_rect().size
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

func _physics_process(delta: float) -> void:
	if ranged == false:
		var direction = global_position.direction_to(Player.global_position)
		velocity = direction * speed * delta
	else:
		var dis = global_position.distance_to(Player.global_position)
		var direction = global_position.direction_to(Player.global_position)
		if dis > wanted_distance + 10:
			velocity = direction * speed * delta
		elif dis < wanted_distance + 10:
			velocity = -direction * speed * delta
		else:
			velocity = Vector2.ZERO
		var player_position = $"../Player".global_position
		var angle := global_position.angle_to_point(player_position)
		$Anchor.rotation = angle
		if $PlayerRange.overlaps_area(PlayerHurtbox) and can_shoot == true:
			spawn_bullet()
			can_shoot = false
			await get_tree().create_timer(cooldown).timeout
			can_shoot = true

	move_and_slide()
	if velocity.x > 0:
		ZombieAnimations.flip_h = false
		ZombieAnimations.play("Walking")
	elif velocity.x < 0:
		ZombieAnimations.flip_h = true
		ZombieAnimations.play("Walking")
	if velocity.y < -5:
		ZombieAnimations.play("Up")
	elif velocity.y > 5:
		ZombieAnimations.play("Down")

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == PlayerHurtbox:
		$"../Player/HurtSound".pitch_scale = randf_range(0.9, 1.1)
		$"../Player/HurtSound".play()
		PlayerHealth.value -= damage

func spawn_bullet() -> void:
	var direction = global_position.direction_to(Player.global_position)
	var bullet: CharacterBody2D = bullet_scene.instantiate()
	$Bullets.add_child(bullet)
	bullet.global_position = BulletSpawner.global_position
	bullet.velocity = bullet.speed * direction
