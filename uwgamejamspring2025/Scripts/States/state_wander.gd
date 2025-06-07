extends State

@export var exit_state : State
@export var dest_tol : float

var patrol_path : Array[Vector2]
var cur_patrol_dest_idx : int

@onready var fish = get_parent()

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

func update() -> State:
	# Check if we have hit our destination
	if (patrol_path.size() != 0):
		var destination = patrol_path[cur_patrol_dest_idx]
		
		if (abs(fish.global_position - destination).length() < dest_tol):
			# If so, call set_next_patrol_destination
			set_next_patrol_destination()
	
	# Check if player is detected
	#get_overlapping_areas()
	#if child.is_in_group("hook"):
		# If so, return state_flee
		#pass
	
	# otherwise, return state_wander
	return self

func enter():
	# Find nearest point
	# Set that as the current point to seek
	pass

func incr_patrol_idx(idx : int) -> int:
	if (idx >= patrol_path.size() - 1):
		return 0
	return idx + 1
