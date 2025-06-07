extends Node2D

@onready var fish = get_parent().get_parent()

func _draw():
	print("Drawing!")
	var center = fish.position
	draw_arc(center, 50, 0, TAU/2, 25, Color(255, 0, 0, 0.25), 100)
