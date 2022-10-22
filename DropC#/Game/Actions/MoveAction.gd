class_name MoveAction
extends Action

var end_position: Vector2i
var start_position: Vector2i

enum {
	WAITING,
	WORKING,
	FINISHED,
}

var tile_coords = {
	FINISHED: Vector2i(0,0),
	WAITING: Vector2i(1,0),
	WORKING: Vector2i(0,1),
}

func _init(source: Agent, end_pos: Vector2i):
	super._init(source)
	type = Action.Type.Move
	start_position = source.pending_grid_position
	end_position = end_pos
	if PathFinder.is_point_solid(end_position):
		end_position = start_position
		valid = false
	else:
		source.pending_grid_position = end_position
		valid = true
	marker_coords = tile_coords[WAITING]
	affected_cells = [end_position]

func execute() -> void:
	marker_coords = tile_coords[WORKING]
	emit_signal("started")
	if used: return
	used = true
	await source.move_to(end_position)
	marker_coords = tile_coords[FINISHED]
	emit_signal("finished")

func debug_string():
	return "Move From ( %d, %d ) To ( %d, %d ) " % [start_position.x, start_position.y,end_position.x, end_position.y]
