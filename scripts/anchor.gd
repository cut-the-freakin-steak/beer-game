extends Node2D

var default_weapon_place = Vector2.RIGHT

func _process(delta: float) -> void:
	var mouse_position := get_global_mouse_position() # Get the mouse position
	var angle := global_position.angle_to_point(mouse_position) # Get angle from anchor to mouse
	rotation = angle # Gives the anchor the angle
