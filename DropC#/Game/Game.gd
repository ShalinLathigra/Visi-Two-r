extends Node2D

@export var _player_controller_path: NodePath
@export var _encounter_path: NodePath

var _player: PlayerController
var _player_agent: Agent
var _encounter: Encounter

enum TURN{
	PLAYER,
	GAME,
}

var turn: TURN = TURN.PLAYER

func _ready():
	_player = get_node(_player_controller_path) as PlayerController
	_encounter = get_node(_encounter_path) as Encounter

	_player_agent = _player.get_avatar()
	if _player_agent: ActionDebug.set_agent(_player_agent)
	_encounter.start(_player_agent)
	_player.start_turn()
	_player.turn_finished.connect(on_player_turn_finished)

# handles the update loop
func _process(_delta: float) -> void:
	if turn == TURN.PLAYER:
		_player_agent.tick()

func on_player_turn_finished() -> void:
	await _player_agent.action_queue_emptied
	turn = TURN.GAME
	print("Game Turn Start")
	get_tree().create_timer(1.0).timeout.connect(on_game_turn_finished)

func on_game_turn_finished() -> void:
		print("Game Turn Finish")
		turn = TURN.PLAYER
		_player.start_turn()
