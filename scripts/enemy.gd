extends CharacterBody2D
class_name Enemy

@export var speed: float = 87.0
@export var ranged: bool = false
@export var damage: int = 20
@export var health: int = 5
@onready var Player = $"../Player"

func _physics_process(delta: float) -> void:
	if ranged == false:
		var direction = Player.position - position
		velocity = direction * speed * delta
		

	move_and_slide()
