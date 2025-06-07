extends ActiveFish

@export var patrol_path_node : Line2D

func _ready():
	current_state = $StateWander
	var state_wander_path = $StateWander
	state_wander_path.initialize(patrol_path_node)
