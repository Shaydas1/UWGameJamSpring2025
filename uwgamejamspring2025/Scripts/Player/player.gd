extends Node2D
class_name Player

@export var cast_strength: float = 5000.0
@export var cast_angle: float = 45

@onready var hook : Hook

var hook_held : bool


func _ready():
	hook = get_node("Hook")
	on_hook_exit_water()
	
	hook.initialize(self)
	$JerkController.initialize(hook)
	
	hook.exited_water.connect(self.on_hook_exit_water)
	hook.entered_water.connect(self.on_hook_enter_water)


func _process(delta):
	if hook_held:
		if Input.is_action_just_pressed("ui_accept"):
			cast_hook()
		

func on_hook_exit_water():
	hook.disable()
	$JerkController.disable()
	
	hook.set_deferred("position", Vector2.ZERO)
	hook_held = true
	


func on_hook_enter_water():
	$JerkController.enable()


func cast_hook():
	hook.enable()
	hook.cast(cast_strength, cast_angle)
	hook_held = false
