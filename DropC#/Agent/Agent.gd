class_name Agent
extends Sprite2D

signal action_queued (action: Action)
signal action_started (action: Action)
signal action_finished (action: Action)

var grid_position: Vector2i
var pending_grid_position: Vector2i
const _duration: float = 0.5

func _ready():
	grid_position = PathFinder.local_to_point(position)

func set_grid_position(g_pos: Vector2i) -> void:
	grid_position = g_pos
	position = PathFinder.point_to_local(grid_position)

func get_pending_grid_position() -> Vector2i:
	var ret = grid_position
	for action in _action_queue:
		if action is SMoveInDirAction:
			ret = action.end_grid_position
	return ret
	
###
# Action Queue Handling
###
var _action_queue: Array[Action]
var _working: bool
var _current_index: int

func add_to_queue(action: Action) -> void:
	_action_queue.push_back(action)
	emit_signal("action_queued", action)

func _process(_delta):
	if not _working and _current_index < _action_queue.size():
		_working = true
		var current_action = _action_queue[_current_index]
		emit_signal("action_started", current_action)
		await current_action.invoke()
		emit_signal("action_finished", current_action)
		_current_index += 1
		_working = false

###
# World Interactions
###
func move_to(g_pos: Vector2i, blocking: bool) -> bool:
	if PathFinder.is_point_solid(g_pos): return false
	
	var dest: Vector2 = PathFinder.point_to_local(g_pos)
	var c: Callable = Callable(set_grid_position)
	c = c.bind(g_pos)
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", dest, _duration)
	tween.tween_callback(c)
	
	if blocking: await tween.finished
	return true
