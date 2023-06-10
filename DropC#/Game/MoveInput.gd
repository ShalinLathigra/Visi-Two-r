extends Node

var _avatar: Agent

func set_avatar(agent: Agent):
	_avatar = agent

###
# Action inputs
###
func _input(event):
	# Left click to enter tentacle control mode. Set working to true
	# Right click to exit tc mode

	# movement here
	if (event.is_action_pressed("move_left")):
		generate_move_action(Vector2i.LEFT)
	if (event.is_action_pressed("move_right")):
		generate_move_action(Vector2i.RIGHT)
	if (event.is_action_pressed("move_up")):
		generate_move_action(Vector2i.UP)
	if (event.is_action_pressed("move_down")):
		generate_move_action(Vector2i.DOWN)


func generate_move_action (dir: Vector2i) -> void:
	var next = MoveAction.new(_avatar, dir + _avatar.pending_grid_position)
	if not next.valid: return
	if _used_actions.size() <= 0:
		_used_actions.push_back(next)
	else:
		var last = _used_actions.back()
		var last_move = last as MoveAction
		if last_move.start_position == next.end_position:
			_used_actions.pop_back()
		else:
			_used_actions.push_back(next)
	var next_set: Array[Action] = [next]
	_avatar.add_to_queue(next_set)
