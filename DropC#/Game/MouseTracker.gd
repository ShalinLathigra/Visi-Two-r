extends GridObject
class_name MouseTracker

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var frame_grid_position = PathFinder.local_to_point(event.position)
		if frame_grid_position != grid_position:
			set_grid_position(frame_grid_position)
