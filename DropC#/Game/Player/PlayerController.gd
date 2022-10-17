class_name PlayerController
extends Node2D

# emitted when the controller runs out of actions
signal turn_started
signal turn_finished

@export var _player_avatar_path: NodePath
@export var _encounter_path: NodePath

var _player_avatar: Agent
var _encounter: Encounter

func get_avatar() -> Agent: return _player_avatar

func _ready() -> void:
	_player_avatar = get_node(_player_avatar_path) as Agent
	_encounter = get_node(_encounter_path) as Encounter

###
# Action inputs
###
func _input(event):
	if (event.is_action_pressed("move_left")): 
		_player_avatar.add_to_queue(move(Vector2i.LEFT))
	if (event.is_action_pressed("move_right")): 
		_player_avatar.add_to_queue(move(Vector2i.RIGHT))
	if (event.is_action_pressed("move_up")): 
		_player_avatar.add_to_queue(move(Vector2i.UP))
	if (event.is_action_pressed("move_down")): 
		_player_avatar.add_to_queue(move(Vector2i.DOWN))

func move(direction: Vector2i) -> SMoveInDirAction:
	return SMoveInDirAction.new(direction, _player_avatar, true, true)
