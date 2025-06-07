extends Node
class_name RodController

@export var reel_strength: float = 100
@export var jerk_strength: float = 500

@onready var hook : Hook

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
 	


func disable():
	enabled = false


func _process(delta):
	if not enabled:
		return
	
	if Input.is_action_just_pressed("reel"):
		hook.jerk(jerk_strength)
		hook.start_reeling(reel_strength)
	
	if Input.is_action_just_released("reel"):
		hook.stop_reeling()
		hook.end_jerk()
		
