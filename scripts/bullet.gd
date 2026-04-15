extends CharacterBody2D


@export var speed: float = 150.0
@onready var player_hurtbox: Area2D = $"../../../Player/HurtBox"
@onready var player_health: ProgressBar = $"../../../Player/HUD/HealthBar"
@onready var cop: CharacterBody2D = $"../.."

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == player_hurtbox:
		player_health.value -= cop.damage
		queue_free()
	else:
		queue_free()
