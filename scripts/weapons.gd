extends Marker2D
class_name Weapons

signal new_weapon

@export var damage = 2
@onready var player: CharacterBody2D = $"../Player"
@onready var player_hurtbox: Area2D = $"../Player/HurtBox"
@onready var weapon_default: Marker2D = $"../Player/Anchor/WeaponDefault"
@onready var beer_weapon_scene: PackedScene = preload("res://scenes/beer_bottle_weapon.tscn")
var can_shoot := true
var has_weapon: bool = false
var ran: bool = false
var default_weapon_place = Vector2.RIGHT

func _process(_delta: float) -> void:
	if ran == false:
		if $PickUpRange.overlaps_area(player_hurtbox) == false:
			$PickUpRange/Label.hide()
		else:
			$PickUpRange/Label.show()
			if Input.is_action_pressed("pick_up"):
				player.has_weapon = true
				has_weapon = true
				$PickUpRange.queue_free()
				queue_free()
	if has_weapon == true and ran == false:
		var beer_weapon: Weapons = beer_weapon_scene.instantiate()
		$"../Player/Anchor".add_child(beer_weapon)
		beer_weapon.global_position = weapon_default.global_position
		new_weapon.emit()
		ran = true

	if has_weapon == true:
		var mouse_position := get_global_mouse_position()
		var angle := global_position.angle_to_point(mouse_position)
		rotation = angle
		if Input.is_action_just_pressed("spitball"):
			hide()
		if Input.is_action_just_pressed("weapon2"):
			show()
		if Input.is_action_pressed("shoot") and visible == true:
			if $Range.is_colliding():
				var hit = $Range.get_collider()
				if hit.is_in_group("enemy"):
					hit.health -= damage
					if hit.health == 0:
						hit.queue_free()
