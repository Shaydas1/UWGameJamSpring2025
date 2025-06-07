extends Node2D
class_name Player

@export var cast_strength: float = 2500.0
@export var cast_angle: float = 0

@onready var hook : Hook

var hook_held : bool


func _ready():
	hook = get_node("Hook")
	on_hook_exit_water()
	
	hook.initialize(self)
	$JerkController.initialize(hook)
	$CastController.initialize(hook)
	
	hook.exited_water.connect(self.on_hook_exit_water)
	hook.entered_water.connect(self.on_hook_enter_water)
	
	$CastController.on_cast.connect(self.on_cast)

func on_hook_exit_water():
	hook.disable()
	$JerkController.disable()
	$CastController.enable()
	
	hook.set_deferred("position", Vector2.ZERO)
	hook_held = true
	
	for fish in hook.caught_fish:
		print(fish.type.score)


func on_hook_enter_water():
	$JerkController.enable()


func on_cast():
	hook.enable()
	$JerkController.enable()
	$CastController.disable()
	hook_held = false
