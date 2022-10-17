extends Node2D

@export var _player_controller_path: NodePath
@export var _encounter_path: NodePath

var _player: PlayerController
var _encounter: Encounter


func _ready():
	_player = get_node(_player_controller_path) as PlayerController
	_encounter = get_node(_encounter_path) as Encounter
	# Base the out of actions signal connection on this? Maybe don't even use it.
	#var consume_callable = Callable(_encounter.consume)
	#_player.action_readied.connect(_encounter.consume)
	
	_encounter.start(_player.get_avatar())
	
