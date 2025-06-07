extends Node2D
class_name Player

@export var cast_strength: float = 1000.0
@export var cast_angle: float = 45

@export var reel_strength: float = 1000
@export var jerk_strength: float = 1000

@onready var hook : Hook

var hook_held : bool


func _ready():
	hook = get_node("Hook")
	take_hook()
	
	hook.exited_water.connect(self.take_hook)
	


func _process(delta):
	if hook_held:
		if Input.is_action_just_pressed("ui_accept"):
			cast_hook()
		
	else:
		if Input.is_action_just_pressed("ui_accept"):
			reel_hook(delta)


func take_hook():
	
	hook.pause(true)
	hook.set_deferred("position", Vector2.ZERO)
	hook.set_deferred("linear_velocity", Vector2.ZERO)
	hook_held = true


func cast_hook():
	var direction = Vector2.UP.rotated(deg_to_rad(cast_angle))
	hook.pause(false)
	hook.call_deferred("apply_central_impulse", direction * cast_strength)
	hook_held = false


func reel_hook(delta):
	var direction = (global_position - hook.global_position).normalized()		
	hook.call_deferred("apply_central_impulse", direction * reel_strength)
	
