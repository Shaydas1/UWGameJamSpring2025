extends CharacterBody2D
class_name ActiveFish

@export var type : FishType

var next_state : State
var current_state : State

@export var move_speed : int

# state machine logic
func _process(delta: float) -> void:
	update_state(delta)

func update_state(delta: float) -> void:
	next_state = current_state.update()
	
	if next_state != current_state:
		current_state.end()
		current_state = next_state
		current_state.enter()
