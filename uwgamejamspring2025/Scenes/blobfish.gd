extends ActiveFish

@export var patrol_path_node : PatrolPath

func _ready():
	current_state = $StateWander
	var state_wander_path = $StateWander
	state_wander_path.initialize(patrol_path_node)
