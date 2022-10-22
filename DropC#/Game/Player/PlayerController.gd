class_name PlayerController
extends Node2D

# emitted when the controller runs out of actions
signal turn_finished
signal turn_started

@export var _player_avatar_path: NodePath
@export var _encounter_path: NodePath
@export_range(0, 16, 1) var max_used_actions: int = 3


var _player_avatar: Agent
var _encounter: Encounter
var _used_actions: Array[Action]

func get_avatar() -> Agent: return _player_avatar

func _ready() -> void:
	_player_avatar = get_node(_player_avatar_path) as Agent
	_encounter = get_node(_encounter_path) as Encounter

func start_turn() -> void:
	_used_actions = []
	emit_signal("turn_started")

###
# Action inputs
###
func _input(event):
	if _used_actions.size() >= max_used_actions: return
	if (event.is_action_pressed("move_left")):
		generate_move_action(Vector2i.LEFT)
	if (event.is_action_pressed("move_right")):
		generate_move_action(Vector2i.RIGHT)
	if (event.is_action_pressed("move_up")):
		generate_move_action(Vector2i.UP)
	if (event.is_action_pressed("move_down")):
		generate_move_action(Vector2i.DOWN)

	if _used_actions.size() >= max_used_actions:
		emit_signal("turn_finished")

func generate_move_action (dir: Vector2i) -> void:
	var next = MoveAction.new(_player_avatar, dir + _player_avatar.pending_grid_position)
	if not next.valid: return
	var last = _used_actions.back()
	if _used_actions.size() <= 0 or not last is MoveAction:
		_used_actions.push_back(next)
	else:
		var last_move = last as MoveAction
		if last_move.start_position == next.end_position:
			_used_actions.pop_back()
		else:
			_used_actions.push_back(next)

	_player_avatar.add_to_queue(next)

