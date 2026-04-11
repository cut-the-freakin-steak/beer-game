extends CharacterBody2D
class_name projectile


@export var speed := 300.0

func _physics_process(delta: float) -> void:
	move_and_slide()
