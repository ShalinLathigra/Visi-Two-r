class_name SMoveInDirAction
extends SelfAction

var end_grid_position: Vector2i
var _displacement: Vector2i

func _init(dis: Vector2i, targ: Agent, block: bool, should_add: bool):
	super._init(targ, block, should_add)
	_displacement = dis;
	name = "SMoveInDir"
	end_grid_position = target.grid_position + _displacement

func set_displacement(dis: Vector2i) -> void:
	_displacement = dis

func invoke() -> void:
	if not target: return
	used = true
	# if this is successful, return true.
	await target.move_to(target.grid_position + _displacement, _blocking)

func _to_string() -> String:
	return "Action: Move {targ} by {disp}".format({ \
			"targ": String( target.name ) if target else "(null)", \
			"disp": _displacement,})
