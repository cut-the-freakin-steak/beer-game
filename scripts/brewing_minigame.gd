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

@onready var pot: Sprite2D = $Pot
@onready var burner: Sprite2D = $Burner
@onready var jug: Sprite2D = $Jug
@onready var jug_lid: Sprite2D = $JugLid
@onready var funnel: Sprite2D = $Funnel

var gonna_mouse_collide: bool = false
var dragging: bool = false
var collision_target: WeakRef
var drag_velocity: Vector2 = Vector2.ZERO
var last_mouse_position: Vector2 = Vector2.ZERO
var resting_position: Vector2 = Vector2(0, 0)
var things_mouse_on: Array[Area2D] = []

var pot_bottom_should_snap: bool = false
var jug_lid_should_snap: bool = false
var jug_lid_snapped: bool = false
var funnel_should_snap: bool = false
var funnel_snapped: bool = false

func _ready() -> void:
	# i love groups. you can mark certain nodes and then just do stuff on those nodes
	for node in get_tree().get_nodes_in_group("BrewingMouseInteractables"):
		# redefining the loop variable cause its a Node by default and we need it to be an
		# Area2D to get the signals in LSP
		var area: Area2D = node

		# devin, if you're seeing this is just a way to connect signals that isn't in the editor
		# i like it like this because you can see all of the signals in the code
		# instead of having to look in the editor
		# you dont have to do this if you don't want to
		area.mouse_entered.connect(_mouse_entered_thing.bind(area))
		area.mouse_exited.connect(_mouse_exited_thing.bind(area))
	
	burner_area.area_entered.connect(_burner_area_entered)
	jug_lid_area.area_entered.connect(_jug_lid_area_entered)
	funnel_area.area_entered.connect(_funnel_area_entered)

func _process(delta: float):
	thing_dragging_system(delta)

	if pot_bottom_should_snap:
		if not Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			pot.global_position = burner.global_position - Vector2(0, 35)
			pot_bottom_should_snap = false
			gonna_mouse_collide = false

	if jug_lid_should_snap:
		if not Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			jug_lid.global_position = jug.global_position - Vector2(0, 45)
			jug_lid_snapped = true
			jug_lid_should_snap = false
			gonna_mouse_collide = false
	
	if funnel_should_snap:
		if not Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			funnel.global_position = pot.global_position - Vector2(0, 25)
			funnel_snapped = true
			funnel_should_snap = false
			gonna_mouse_collide = false

	if jug_lid_snapped and not dragging:
		jug_lid.z_index = 1
		# jug.z_index = 1
	
	elif jug_lid_snapped and dragging:
		jug_lid.z_index = 0
		# jug.z_index = 0
	
	if funnel_snapped and not dragging:
		funnel.z_index = 1
		# pot.z_index = 1
	
	elif funnel_snapped and dragging:
		funnel.z_index = 0
		# pot.z_index = 0

	if jug_lid_snapped:
		if gonna_mouse_collide:
			if not things_mouse_on.is_empty():
				var target: Area2D = things_mouse_on.back()
				if target == jug_main_area:
					print("raghh")
					pass

				elif target.get_parent() == jug:
					jug_lid.z_index -= 1

				else:
					jug_lid.z_index -= 1

	if funnel_snapped:
		if gonna_mouse_collide:
			if not things_mouse_on.is_empty():
				var target: Area2D = things_mouse_on.back()
				if target == pot_main_area:
					print("waghh")
					pass

				elif target.get_parent() == pot:
					funnel.z_index -= 1

				else:
					funnel.z_index -= 1

func _mouse_entered_thing(area: Area2D) -> void:
	if things_mouse_on.has(area):
		things_mouse_on.erase(area)

	things_mouse_on.append(area)

func _mouse_exited_thing(area: Area2D) -> void:
	things_mouse_on.erase(area)

	if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
		return

	area.get_parent().z_index = 0
	gonna_mouse_collide = false

func _burner_area_entered(area: Area2D) -> void:
	if area == pot_bottom_area:
		pot_bottom_should_snap = true

func _jug_lid_area_entered(area: Area2D) -> void:
	if area == jug_top_area:
		jug_lid_should_snap = true

func _funnel_area_entered(area: Area2D) -> void:
	if area == pot_top_area:
		funnel_should_snap = true

func thing_dragging_system(delta: float) -> void:
	if not things_mouse_on.is_empty():
		var not_last_thing_mouse_on = things_mouse_on.duplicate(true)
		not_last_thing_mouse_on.pop_back()
		for area in not_last_thing_mouse_on:
			area.get_parent().z_index = 0

		if not Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			gonna_mouse_collide = true
			collision_target = weakref(things_mouse_on.back())

			var body_parent: Sprite2D = things_mouse_on.back().get_parent()
			if dragging:
				body_parent.z_index = 0

			else:
				body_parent.z_index = 1

			gonna_mouse_collide = true
			resting_position = things_mouse_on.back().global_position

	if gonna_mouse_collide:
		var mouse_position = get_global_mouse_position()
		last_mouse_position = mouse_position
		var collision_body_area: Area2D = collision_target.get_ref()
		var collision_body: Sprite2D = collision_body_area.get_parent()

		if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
			resting_position = mouse_position
			drag_velocity = (mouse_position - last_mouse_position) / delta
			collision_body.global_position = lerp(collision_body.global_position, mouse_position, 0.2)

			if collision_body == jug and jug_lid_snapped:
				jug_lid.global_position = jug.global_position - Vector2(0, 45)

			elif collision_body == jug_lid and jug_lid_snapped:
				jug_lid_snapped = false

			if collision_body == pot and funnel_snapped:
				funnel.global_position = pot.global_position - Vector2(0, 25)

			elif collision_body == funnel and funnel_snapped:
				funnel_snapped = false

		else:
			collision_body.global_position = lerp(collision_body.global_position, resting_position, 0.1)

			if collision_body == jug and jug_lid_snapped:
				jug_lid.global_position = jug.global_position - Vector2(0, 45)

			if collision_body == pot and funnel_snapped:
				funnel.global_position = pot.global_position - Vector2(0, 25)
