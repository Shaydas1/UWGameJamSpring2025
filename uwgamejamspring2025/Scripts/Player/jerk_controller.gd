extends Node
class_name RodController

@export var reel_strength: float = 100
@export var jerk_strength: float = 500

@onready var can_jerk_timer: Timer = $JerkTimer
@onready var jerk_buffer_timer: Timer = $JerkBuffer


var can_jerk_hook : bool = true

var jerk_buffer_frames = 5
var jerk_buffered = true

@onready var hook : Hook

var enabled : bool = false

func initialize(hook: Hook):
	self.hook = hook


func reset():
	can_jerk_hook = true
	jerk_buffered = false


func _ready():
	can_jerk_timer.connect("timeout", func(): can_jerk_hook = true)
	jerk_buffer_timer.connect("timeout", func(): jerk_buffered = false)

func enable():
	reset()
	enabled = true


func disable():
	enabled = false


func _process(delta):
	if not enabled:
		return
	
	if Input.is_action_just_pressed("ui_accept"):
		jerk_buffered = true
		jerk_buffer_timer.start()
		hook.start_reeling(reel_strength)
	
	if Input.is_action_just_released("ui_accept"):
		jerk_buffered = false
		hook.stop_reeling()
		hook.end_jerk()
		
	if can_jerk_hook and jerk_buffered:
		hook.jerk(jerk_strength)
	
		can_jerk_hook = false
		can_jerk_timer.start()
		
		jerk_buffered = false
