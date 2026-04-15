extends AnimatedSprite2D

@onready var player_hurtbox: Area2D = $"../Player/HurtBox"

func _process(delta: float) -> void:
	if $PlayerRange.overlaps_area(player_hurtbox) == false:
		$PlayerRange/Label.hide()
	else:
		$PlayerRange/Label.show()
		if Input.is_action_pressed("pick_up"):
			$PlayerRange.monitoring = false
			$PlayerRange.monitorable = false
			$".".play("open")
