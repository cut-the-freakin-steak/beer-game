extends Marker2D
class_name Weapons

@onready var Player: CharacterBody2D = $"../Player"
@onready var PlayerHurtbox: Area2D = $"../Player/HurtBox"
@onready var BeerWeaponScene: PackedScene = preload("res://scenes/beer_bottle_weapon.tscn")
var can_shoot := true
var ran: bool = false
var default_weapon_place = Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player.has_weapon == true:
		var mouse_position := get_global_mouse_position()
		var angle := global_position.angle_to_point(mouse_position)
		rotation = angle

	if $PickUpRange.overlaps_area(PlayerHurtbox) == false:
		$PickUpRange/Label.hide()
	else:
		$PickUpRange/Label.show()
		if Input.is_action_pressed("pick_up"):
			Player.has_weapon = true
			queue_free()
	if Player.has_weapon == true and ran == false:
		var BeerWeapon = BeerWeaponScene.instantiate()
		$"../Player/Anchor".reparent(BeerWeapon)
		BeerWeapon.global_position = $"../SpitBall".global_position
		$PickUpRange.queue_free()
		ran = true
