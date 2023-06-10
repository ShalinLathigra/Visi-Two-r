extends Sprite2D
class_name GridObject

var grid_position: Vector2i
var pending_grid_position: Vector2i

func _ready():
	set_grid_position(PathFinder.local_to_point(position))

func set_grid_position(g_pos: Vector2i) -> void:
	grid_position = g_pos
	pending_grid_position = grid_position
	position = PathFinder.point_to_local(grid_position)
