extends CharacterBody2D
class_name Enemy

@export var speed: float = 1750.0
@export var ranged: bool = false
@export var damage: int = 20
@export var health: int = 5
@onready var Player: CharacterBody2D = $"../Player"
@onready var PlayerHurtbox: Area2D = $"../Player/HurtBox"
@onready var PlayerHealth: ProgressBar = $"../Player/HUD/HealthBar"
@onready var spitball_scene: PackedScene = preload("res://scenes/spit_ball.tscn")
@onready var BulletSpawner: Marker2D = $Anchor/Gun/BulletSpawner
var wanted_distance = 90

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
		if $PlayerRange.overlaps_area(PlayerHurtbox):
			spawn_bullet()

	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == PlayerHurtbox:
		$"../Player/HurtSound".pitch_scale = randf_range(0.9, 1.1)
		$"../Player/HurtSound".play()
		PlayerHealth.value -= damage

func spawn_bullet() -> void:
	var direction = global_position.direction_to(Player.global_position)
	var spitball: Projectile = spitball_scene.instantiate()
	spitball.global_position = BulletSpawner.global_position
	spitball.velocity = spitball.speed * direction
