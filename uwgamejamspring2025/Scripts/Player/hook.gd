extends RigidBody2D
class_name Hook

@export var water_gravity_scale : float = 0.8
@export var water_damping : float = 0.3

@export var max_fall_speed : float = 500

@export var max_distance : float
@export var jerk_cut_factor: float = 0.2

signal entered_water
signal exited_water

signal hook_lost

var in_water : bool = false

var reeling : bool = false
var reel_strength : float = false

var enabled : bool = false 


var target : Node2D = null

var caught_fish : Array[CaughtFish] = []

func enable():
	enabled = true
	in_water = false
	reeling = false
	set_gravity()


func disable():
	enabled = false
	$Sprite2D.rotation = 0


func cast(strength: float, angle : float):
	if in_water:
		return
	
	var direction = Vector2.UP.rotated(deg_to_rad(angle))
	call_deferred("apply_central_impulse", direction * strength)
	

func _set_reeling(value: bool):
	if not in_water:
		return
	
	reeling = value
	set_gravity()


func start_reeling(strength: float):
	_set_reeling(true)
	reel_strength = strength


func stop_reeling():
	_set_reeling(false)
	

func _get_direction_to_target() -> Vector2:
	return (target.global_position - global_position).normalized()


func jerk(strength: float):
	if not in_water:
		return _get_direction_to_target
	
	linear_velocity = Vector2.ZERO
	call_deferred("apply_central_impulse", strength * _get_direction_to_target())


func end_jerk():
	if linear_velocity.y < 0:
		linear_velocity.y *= jerk_cut_factor
	
	if linear_velocity.x < 0:
		linear_velocity.x *= 0 

func reel():
	apply_central_force(reel_strength * _get_direction_to_target())


func hook_fish(fish : Node2D):
	fish = fish as ActiveFish
	
	if fish == null:
		return
		
	var new_fish = fish.type.caught_fish.instantiate()
	add_child(new_fish)
	caught_fish.append(new_fish)
	
	fish.queue_free()

func free_fish():
	for fish in caught_fish:
		fish.queue_free()
	
	caught_fish.clear()
	

func initialize(target: Node2D):
	self.target = target


func set_gravity():
	if reeling:
		gravity_scale = 0
		return
		
	if in_water:
		gravity_scale = water_gravity_scale
	
	else:
		gravity_scale = 1


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if not enabled: 
		state.linear_velocity = Vector2.ZERO
		
	if not in_water:
		return
	
	state.linear_velocity.x = move_toward(state.linear_velocity.x, 0.0, 0.1 * state.step)
		

func _physics_process(delta):
	if not enabled:
		return
	
		
	if position.x < 0:
		position.x = 0
		
	if in_water:
		if reeling: 
			reel()
		if linear_velocity.y > max_fall_speed:
			linear_velocity.y = max_fall_speed
		
		var direction = linear_velocity
		direction.y = -abs(direction.y)
		$Sprite2D.rotation = PI/2 + direction.angle()
	
	var offset = global_position - target.global_position
	
	if offset.length() > max_distance and linear_velocity.dot(offset) > 0:
		apply_central_impulse(-linear_velocity.project(offset.normalized())*1.5)
		
func on_enter_water():
	in_water = true
	set_gravity()
	linear_velocity.x = 0
	linear_damp = water_damping
	emit_signal("entered_water")


func on_exit_water():
	in_water = false
	set_gravity()
	linear_damp = 0.1
	emit_signal("exited_water")


func _on_area_entered(area):
	if not enabled:
		return
		
	if area.is_in_group("water"):
		on_enter_water()
	
		
	if area.is_in_group("rock"):
		emit_signal("hook_lost")


func _on_area_exit(area):
	if not enabled:
		return
		
	if area.is_in_group("water"):
		on_exit_water()


func _on_body_entered(body):
	if not enabled:
		return
		
	if body.is_in_group("active_fish"):
		hook_fish(body)
		
