class_name Agent
extends Sprite2D

signal action_declared (action: Action)
signal action_started (action: Action)
signal action_finished (action: Action)
signal action_queue_emptied

var grid_position: Vector2i
var pending_grid_position: Vector2i
const _duration: float = 0.3

func _ready():
	grid_position = PathFinder.local_to_point(position)

func set_grid_position(g_pos: Vector2i) -> void:
	grid_position = g_pos
	pending_grid_position = grid_position
	position = PathFinder.point_to_local(grid_position)

###
# Action Queue Handling
###
var _action_queue: Array[Action]
var _working: bool

func add_to_queue(action: Action) -> void:
	emit_signal("action_declared", action)
	_action_queue.push_back(action)

func tick():
	if not _working and _action_queue.size() > 0:
		_working = true
		var current_action: Action = _action_queue[0]
		_action_queue.erase(current_action)
		emit_signal("action_started", current_action)
		await current_action.execute()
		emit_signal("action_finished", current_action)
		_working = false
	elif _action_queue.size() <= 0:
		emit_signal("action_queue_emptied")

###
# World Interactions
###
func move_to(g_pos: Vector2i) -> bool:
	if PathFinder.is_point_solid(g_pos): return false

	var dest: Vector2 = PathFinder.point_to_local(g_pos)
	var duration_scaler: float = (g_pos - grid_position).length() / 1.0

	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position", dest, _duration * duration_scaler)
	await tween.finished
	grid_position = PathFinder.local_to_point(position)

	return true
