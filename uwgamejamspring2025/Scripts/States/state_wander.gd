extends State

@export var exit_state : State
@export var dest_tol : float

var patrol_path : Array[int]
var cur_patrol_dest_idx : int

var fish = get_parent()

func initialize( patrol_path : Array[int] ) -> void:
	self.patrol_path = patrol_path

func _physics_process(delta: float) -> void:
	fish.move_and_slide()

func set_next_patrol_destination() -> void:
	cur_patrol_dest_idx += 1
	var destination = patrol_path[cur_patrol_dest_idx]
		
	fish.velocity.x = (destination - fish.global_position).x
	fish.velocity.y = (destination - fish.global_position).y

func update() -> State:
	# Check if we have hit our destination
	var destination = patrol_path[cur_patrol_dest_idx]
	if (abs(fish.global_position - destination) < dest_tol):
		# If so, call set_next_patrol_destination
		set_next_patrol_destination()
	
	# Check if player is detected
	# If so, return state_flee
	
	# return state_wander
	return self

func enter():
	# Find nearest point
	# Set that as the current point to seek
	pass
