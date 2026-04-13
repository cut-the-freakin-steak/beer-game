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
		

	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if ranged == true:
		return
	else:
		if area == PlayerHurtbox:
			$"../Player/HurtSound".pitch_scale = randf_range(0.9, 1.1)
			$"../Player/HurtSound".play()
			PlayerHealth.value -= damage
