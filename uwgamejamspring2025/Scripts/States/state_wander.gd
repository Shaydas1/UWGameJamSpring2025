extends State

@export var exit_state : State
@export var dest_tol : float

var patrol_path : Array[Vector2]
var cur_patrol_dest_idx : int

@onready var fish = get_parent()
@onready var threat_box = $ThreatBox

func initialize(patrol_path_node : PatrolPath) -> void:
	patrol_path = patrol_path_node.get_patrol_path()
	
	cur_patrol_dest_idx = 0
	set_next_patrol_destination()
	

func _physics_process(delta: float) -> void:
	fish.move_and_slide()

# Assumes a patrol path exists.
func set_next_patrol_destination() -> void:
	cur_patrol_dest_idx = incr_patrol_idx(cur_patrol_dest_idx)
	var destination = patrol_path[cur_patrol_dest_idx]
	
	var move_direction = (destination - fish.global_position).normalized()
	
	fish.velocity.x = move_direction.x * fish.move_speed
	fish.velocity.y = move_direction.y * fish.move_speed

func incr_patrol_idx(idx : int) -> int:
	if (idx >= patrol_path.size() - 1):
		return 0
	return idx + 1

# Inherited methdos
func update() -> State:
	# Check if we have hit our destination
	if (patrol_path.size() != 0):
		var destination = patrol_path[cur_patrol_dest_idx]
		
		if (abs(fish.global_position - destination).length() < dest_tol):
			# If so, call set_next_patrol_destination
			set_next_patrol_destination()
	
	# Check if player is detected
	var overlapping_bodies = threat_box.get_overlapping_areas()
	
	# OVERLAP DETECTION NOT TESTED YET
	for overlapping_body in overlapping_bodies:
		if overlapping_body.is_in_group("hook"):
			# If so, set the location of the player in state_flee and return state_flee
			exit_state.threat_location = overlapping_body
			return exit_state
	
	# FOR TESTING:
	if Input.is_action_just_released("ui_accept"):
		exit_state.threat_location = Vector2(0, 0)
		return exit_state
	
	# otherwise, return state_wander
	return self

func dist_from_fish(point : Vector2) -> float:
	return (point - fish.global_position).length()

func enter():
	# need a patrol path to return to, or we just do nothing
	if patrol_path.size() <= 0:
		return
	
	# find nearest point
	var closest_patrol_point_idx = 0
	
	for idx in range(patrol_path.size()):
		if dist_from_fish(patrol_path[idx]) < dist_from_fish(patrol_path[closest_patrol_point_idx]):
			closest_patrol_point_idx = idx
	 
	# set that as the current point to seek
	cur_patrol_dest_idx = closest_patrol_point_idx
	var destination = patrol_path[closest_patrol_point_idx]
	
	var move_direction = (destination - fish.global_position).normalized()
	
	fish.velocity.x = move_direction.x * fish.move_speed
	fish.velocity.y = move_direction.y * fish.move_speed
