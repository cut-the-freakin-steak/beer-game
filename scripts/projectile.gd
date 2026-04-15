extends CharacterBody2D
class_name Projectile

@export var speed: float = 300.0
@export var damage = 1
@onready var zombie_hitbox: Area2D = $"../../../../Zombie/Hitbox"
@onready var zombie: CharacterBody2D = $"../../../../Zombie"
@onready var cop_hitbox: Area2D = $"../../../../Cop/Hitbox"
@onready var cop: CharacterBody2D = $"../../../../Cop"

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == zombie_hitbox:
		zombie.health -= damage
		queue_free()
		if zombie.health == 0:
			zombie.queue_free()
	elif area == cop_hitbox:
		cop.health -= damage
		queue_free()
		if cop.health == 0:
			cop.queue_free()
