extends Control

# doing := instead of just = during variable declarations helps the GDScript parser get the types of
# variables better, so since i did that, the "pot" variable knows its a Sprite2D, so it'll give
# me all of the Sprite2D functions and variables
@onready var pot: Sprite2D = $Pot
@onready var burner: Sprite2D = $Burner
@onready var jug: Sprite2D = $Jug
@onready var jug_lid: Sprite2D = $JugLid
@onready var funnel: Sprite2D = $Funnel

func _ready() -> void:
	# devin, if you're seeing this is just a way to connect signals that isn't in the editor
	# i like it like this because you can see all of the signals in the code
	# instead of having to look in the editor
	# you dont have to do this if you don't want to
	pass
