extends CharacterBody2D
class_name ActiveFish

@export var type : FishType

@export var move_speed : int
@export var threat_detection_angles : Array[Vector2]

var next_state : State
var current_state : State

# state machine logic
func _process(delta: float) -> void:
	update_state(delta)

func update_state(delta: float) -> void:
	if (!current_state):
		return
	
	next_state = current_state.update()
	
	if next_state != current_state:
		current_state.end()
		current_state = next_state
		current_state.enter()
