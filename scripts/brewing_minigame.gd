extends Control

# doing := instead of just = during variable declarations helps the GDScript parser get the types of
# variables better, so since i did that, the "pot" variable knows its a Sprite2D, so it'll give
# me all of the Sprite2D functions and variables
@onready var pot_top_area: Area2D = $Pot/TopArea
@onready var pot_bottom_area: Area2D = $Pot/BottomArea
@onready var pot_main_area: Area2D = $Pot/MainArea
@onready var jug_top_area: Area2D = $Jug/TopArea
@onready var jug_main_area: Area2D = $Jug/MainArea
@onready var jug_lid_area: Area2D = $JugLid/Area2D
@onready var funnel_area: Area2D = $Funnel/Area2D
@onready var burner_area: Area2D = $Burner/Area2D

var gonna_mouse_collide: bool = false
var dragging: bool = false
var collision_target: WeakRef
var drag_velocity: Vector2 = Vector2.ZERO
var last_mouse_position: Vector2 = Vector2.ZERO
var resting_position: Vector2 = Vector2(0, 0)

func _ready() -> void:
	# devin, if you're seeing this is just a way to connect signals that isn't in the editor
	# i like it like this because you can see all of the signals in the code
	# instead of having to look in the editor
	# you dont have to do this if you don't want to
	# pot_main_area.mouse_entered.connect(_mouse_entered_shape.bind(pot_main_area))
	for node in get_tree().get_nodes_in_group("BrewingMouseInteractables"):
		print(node)
		var area: Area2D = node
		area.mouse_entered.connect(_mouse_entered_shape.bind(area))
		area.mouse_exited.connect(_mouse_exited_shape)

func _process(delta: float):
	if gonna_mouse_collide:
		var mouse_position = get_global_mouse_position()
		last_mouse_position = mouse_position
		var collision_body_area: Area2D = collision_target.get_ref()
		var collision_body: Sprite2D = collision_body_area.get_parent()

		if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			resting_position = mouse_position
			drag_velocity = (mouse_position - last_mouse_position) / delta
			collision_body.global_position = lerp(collision_body.global_position, mouse_position, 0.2)
		else:
			collision_body.global_position = lerp(collision_body.global_position, resting_position, 0.1)

func _mouse_entered_shape(body: Area2D) -> void:
	gonna_mouse_collide = true
	resting_position = body.global_position
	collision_target = weakref(body)

func _mouse_exited_shape() -> void:
	if not Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
		gonna_mouse_collide = false
