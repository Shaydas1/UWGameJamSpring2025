extends Node
class_name CastController

@export var cast_strength: float = 5000.0

@export var max_size : float = 2

@export var angle_speed : float = PI/4
@export var strength_speed : float = 0.75 

var angle = 0
var stength = 0.1

@onready var hook : Hook

signal on_cast

var enabled : bool = false

func initialize(hook: Hook):
	self.hook = hook


func reset():
	pass


func _ready():
	pass
	
func enable():
	reset()
	enabled = true
	$CastIndicator.show()


func disable():
	enabled = false
	$CastIndicator.hide()


func _process(delta):
	if not enabled:
		return 
	
	var angle_direction = 0
	if Input.is_action_pressed("cast_angle_down"):
		angle_direction = 1
		
	elif Input.is_action_pressed("cast_angle_up"):
		angle_direction = -1
		
	$CastIndicator.rotation += angle_direction * angle_speed * delta
	$CastIndicator.rotation = clampf(
		$CastIndicator.rotation,
		0,
		3 * PI/4
	)

	var strength_direction = 0
	if Input.is_action_pressed("cast_strength_down"):
		strength_direction = -1
		
	elif Input.is_action_pressed("cast_strength_up"):
		strength_direction = 1
		
	$CastIndicator.scale = (
		$CastIndicator.scale + 
		Vector2(
			strength_direction * delta,
			strength_direction * delta
			)
		).clamp(
			Vector2(0.8, 0.8), 
			Vector2(max_size, max_size)
			)
			
	if Input.is_action_just_pressed("cast"):
		hook.cast(
			$CastIndicator.scale.x * cast_strength, 
			$CastIndicator.rotation_degrees)
		emit_signal("on_cast")
	
