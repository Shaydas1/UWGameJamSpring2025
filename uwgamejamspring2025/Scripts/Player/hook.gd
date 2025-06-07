extends RigidBody2D
class_name Hook

@export var water_gravity_scale : float = 0.1
@export var water_damping : float = 0

@export var max_speed : float = 100000

signal entered_water
signal exited_water

signal hook_lost

var in_water := false
var paused := false 


func pause(value: bool):
	set_deferred("paused", value)
	set_deferred("sleeping", value)
	set_deferred("freeze", value)


func on_enter_water():
	if paused:
		return
	print_debug("enter water")
		
	gravity_scale = water_gravity_scale
	linear_damp = water_damping
	in_water = true
	emit_signal("entered_water")


func on_exit_water():
	if paused:
		return
	print_debug("exit water")
		
	gravity_scale = 1.0
	linear_damp = 0.1
	in_water = false
	emit_signal("exited_water")


func _on_area_entered(area):

	if area.is_in_group("water"):
		on_enter_water()
	
	if paused:
		return
		
	if area.is_in_group("rock"):
		emit_signal("hook_lost")

func _on_area_exit(area):
	if area.is_in_group("water"):
		on_exit_water()


func _physics_process(delta):		
	if in_water: 
		if position.x < 0:
			position.x = 0
		
		var vel = linear_velocity
		
		vel.y = clamp(vel.y, -INF, 100)
		
		linear_velocity.clamp()
		if linear_velocity.length() > max_speed:
			linear_velocity = linear_velocity.normalized() * max_speed
		
