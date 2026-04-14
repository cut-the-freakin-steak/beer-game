extends Node2D

# preload and load are very similar, and if pointing to a .tscn file, they return a PackedScene
# preload loads the scene on game startup, so only use it for things that will be used a lot,
# such as this spitball scene.
# load is used for mostly single instantiation stuff, like a one-time object you need to spawn
@onready var projectile_list: Node = $Projectiles
@onready var projectile_spawn_pos: Marker2D = $SpitBall/ProjectileSpawn
@onready var spitball_scene: PackedScene = preload("res://scenes/spit_ball.tscn")
var can_shoot := true

var default_weapon_place = Vector2.RIGHT

func _process(_delta: float) -> void:
	var mouse_position := get_global_mouse_position() # Get the mouse position
	var angle := global_position.angle_to_point(mouse_position) # Get angle from anchor to mouse
	rotation = angle # Gives the anchor the angle

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot") and can_shoot == true and $SpitBall.visible == true:
		spawn_spitball()
		can_shoot = false
		await get_tree().create_timer(0.2).timeout
		can_shoot = true

func spawn_spitball() -> void:
	var mouse_position := get_global_mouse_position() # Get the mouse position
	var direction := projectile_spawn_pos.global_position.direction_to(mouse_position)

	# instantiate makes the Node from the PackedScene
	var spitball: Projectile = spitball_scene.instantiate()

	# to put an instantiated node in the actual game (in the scene tree),
	# add it to an existing node as a child
	projectile_list.add_child(spitball)
	$"../SpitBallSound".pitch_scale = randf_range(0.9, 1.1)
	$"../SpitBallSound".play()

	spitball.global_position = projectile_spawn_pos.global_position
	spitball.velocity = spitball.speed * direction
