extends Node
class_name CaughtFish

@export var type : FishType

var current_state
var next_state

# state machine logic
func _process(delta: float) -> void:
	update_state(delta)

func update_state(delta: float) -> void:
	next_state = current_state.update()
	
	if next_state != current_state:
		current_state.end()
		current_state = next_state
		current_state.enter()
