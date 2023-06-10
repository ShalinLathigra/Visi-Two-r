class_name PlayerController
extends Node2D

# emitted when the controller runs out of actions
signal turn_finished
signal turn_started

@export var _encounter_path: NodePath
@export_range(0, 16, 1) var max_used_actions: int = 3


var _avatar: Agent
var _marker: MouseTracker
var _encounter: Encounter
var _used_actions: Array[Action]

func get_avatar() -> Agent: return _avatar

func _ready() -> void:
	_avatar = $PlayerAvatar as Agent
	_encounter = get_node(_encounter_path) as Encounter

	for child in get_children():
		if child.has_method("set_avatar"):
			child.set_avatar(_avatar)

func start_turn() -> void:
	_used_actions = []
	emit_signal("turn_started")

###
# Action inputs
###
func _input(event):
	if _used_actions.size() >= max_used_actions: return

	if _used_actions.size() >= max_used_actions:
		emit_signal("turn_finished")

