extends CharacterBody2D


@export var speed: float = 150.0
@onready var PlayerHurtbox: Area2D = $"../../../Player/HurtBox"
@onready var PlayerHealth: ProgressBar = $"../../../Player/HUD/HealthBar"
@onready var Cop: CharacterBody2D = $"../.."

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == PlayerHurtbox:
		PlayerHealth.value -= Cop.damage
