extends State

@export var exit_state : State
@export var dest_tol : float

var patrol_path : Line2D
var cur_patrol_dest_idx : int

@onready var fish = get_parent()
@onready var threat_box = $ThreatBox

func initialize(non_global_patrol_path : Line2D) -> void:
	
	patrol_path = non_global_patrol_path
	
	# The patrol path is made relative to (0, 0), we want the path in global pos
	for idx in range(non_global_patrol_path.get_point_count()):
		patrol_path.set_point_position(
			idx,
			non_global_patrol_path.get_point_position(idx) + fish.global_position
			)
	
	cur_patrol_dest_idx = 0
	set_next_patrol_destination()
	

func _physics_process(delta: float) -> void:
	fish.move_and_slide()

# Assumes a patrol path exists.
func set_next_patrol_destination() -> void:
	cur_patrol_dest_idx = incr_patrol_idx(cur_patrol_dest_idx)
	var destination = patrol_path.get_point_position(cur_patrol_dest_idx)
	
	var move_direction = (destination - fish.global_position).normalized()
	
	fish.velocity.x = move_direction.x * fish.move_speed
	fish.velocity.y = move_direction.y * fish.move_speed

func incr_patrol_idx(idx : int) -> int:
	if (idx >= patrol_path.get_point_count() - 1):
		return 0
	return idx + 1

# Inherited methods
func update() -> State:
	# Check if we have hit our destination
	if (patrol_path.get_point_count() != 0):
		var destination = patrol_path.get_point_position(cur_patrol_dest_idx)
		
		if (abs(fish.global_position - destination).length() < dest_tol):
			# If so, call set_next_patrol_destination
			set_next_patrol_destination()
	
	# Check if player is detected
	var overlapping_bodies = threat_box.get_overlapping_areas()
	
	for overlapping_body in overlapping_bodies:
		if overlapping_body.is_in_group("hook"):
			# Check if player is in "seen" angles
			var overlapping_body_angle = (overlapping_body.global_position - fish.global_position).angle()
			for angle_pair in fish.threat_detection_angles:
				if angle_pair.x <= overlapping_body_angle and overlapping_body_angle <= angle_pair.y:
					print("THREAT DETECTED, FLEEING")
					# If so, set the location of the player in state_flee and return state_flee
					exit_state.threat_location = overlapping_body.global_position
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
	if patrol_path.get_point_count() <= 0:
		return
	
	# find nearest point
	var closest_patrol_point_idx = 0
	
	for idx in range(patrol_path.get_point_count()):
		var idx_point_dist = dist_from_fish(patrol_path.get_point_position(idx))
		var min_dist = dist_from_fish(patrol_path.get_point_position(closest_patrol_point_idx))
		if idx_point_dist < min_dist:
			closest_patrol_point_idx = idx
	 
	# set that as the current point to seek
	cur_patrol_dest_idx = closest_patrol_point_idx
	var destination = patrol_path.get_point_position(closest_patrol_point_idx)
	
	var move_direction = (destination - fish.global_position).normalized()
	
	fish.velocity.x = move_direction.x * fish.move_speed
	fish.velocity.y = move_direction.y * fish.move_speed
