extends Node

class_name PatrolPath

# Patrol pathes are assumed to only contain points,
# in the order they should be patrolled.

func get_patrol_path() -> Array[Vector2]:
	var point_nodes = get_children()
	var points : Array[Vector2]
	
	for point_node in point_nodes:
		points.append(point_node.global_position)
	
	return points
