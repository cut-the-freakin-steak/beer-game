extends Marker2D
class_name Weapons

signal new_weapon

@onready var Player: CharacterBody2D = $"../Player"
@onready var PlayerHurtbox: Area2D = $"../Player/HurtBox"
@onready var WeaponDefault: Marker2D = $"../Player/Anchor/WeaponDefault"
@onready var BeerWeaponScene: PackedScene = preload("res://scenes/beer_bottle_weapon.tscn")
var can_shoot := true
var has_weapon: bool = false
var ran: bool = false
var default_weapon_place = Vector2.RIGHT

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_weapon == true:
		var mouse_position := get_global_mouse_position()
		var angle := global_position.angle_to_point(mouse_position)
		rotation = angle
		if Input.is_action_pressed("spitball"):
			hide()
		elif Input.is_action_pressed("weapon2"):
			show()

	if ran == false:
		if $PickUpRange.overlaps_area(PlayerHurtbox) == false:
			$PickUpRange/Label.hide()
		else:
			$PickUpRange/Label.show()
			if Input.is_action_pressed("pick_up"):
				Player.has_weapon = true
				has_weapon = true
				$PickUpRange.monitoring = false
				$PickUpRange.monitorable = false
				queue_free()
	if has_weapon == true and ran == false:
		var BeerWeapon: Weapons = BeerWeaponScene.instantiate()
		$"../Player/Anchor".add_child(BeerWeapon)
		BeerWeapon.global_position = WeaponDefault.global_position
		new_weapon.emit()
		ran = true
