extends State

@export var exit_state : State

@onready var fish = get_parent()
@onready var done_fleeing = false
@onready var timer = $Timer

var threat_location : Vector2

func update():
	if done_fleeing:
		return exit_state
	return self

func enter():
	done_fleeing = false
	
	timer.start()
	
	var move_direction = (fish.global_position - threat_location).normalized()
	
	fish.velocity.x = move_direction.x * fish.move_speed
	fish.velocity.y = move_direction.y * fish.move_speed


func _on_timer_timeout() -> void:
	timer.stop()
	done_fleeing = true
