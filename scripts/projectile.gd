extends CharacterBody2D
class_name Projectile

@export var speed: float = 300.0
@export var damage = 1
@onready var ZombieHitbox: Area2D = $"../../../../Zombie/Hitbox"
@onready var Zombie: CharacterBody2D = $"../../../../Zombie"
@onready var CopHitbox: Area2D = $"../../../../Cop/Hitbox"
@onready var Cop: CharacterBody2D = $"../../../../Cop"

func _physics_process(_delta: float) -> void:
	move_and_slide()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area == ZombieHitbox:
		Zombie.health -= damage
		queue_free()
		if Zombie.health == 0:
			Zombie.queue_free()
	elif area == CopHitbox:
		Cop.health -= damage
		queue_free()
		if Cop.health == 0:
			Cop.queue_free()
