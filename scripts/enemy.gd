extends CharacterBody2D
class_name Enemy

@export var speed: float = 87.0
@export var ranged: bool = false
@export var damage: int = 20
@export var health: int = 5
@onready var Player: CharacterBody2D = $"../Player"
@onready var PlayerHurtbox: Area2D = $"../Player/HurtBox"
@onready var PlayerHealth: ProgressBar = $"../Player/HUD/HealthBar"

func _physics_process(delta: float) -> void:
	if ranged == false:
		var direction = Player.position - position
		velocity = direction * speed * delta
	else:
		if $RangeToPlayer.overlaps_area(PlayerHurtbox):
			pass
		else:
			var direction = Player.position - position
			velocity = direction * speed * delta
		var player_position = $"../Player".global_position
		var angle := global_position.angle_to_point(player_position)
		$Anchor.rotation = angle

	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == PlayerHurtbox:
		$"../Player/HurtSound".pitch_scale = randf_range(0.9, 1.1)
		$"../Player/HurtSound".play()
		PlayerHealth.value -= damage

func _on_range_to_player_area_entered(area: Area2D) -> void:
	if area == PlayerHurtbox:
		var direction = Player.position - position
		velocity = -direction * speed
