class_name Encounter
extends Node2D


# Player Game State
# Level Game State
# Spawn position marker

# State tree setup

@export var encounterMap: TileMap
@export var spawnPoint: Marker2D
@export var start_on_ready: bool = true

func _ready() -> void:
	start(null)

func start(player: Agent) -> void:
	if encounterMap: PathFinder.set_map(encounterMap)
	if player: 
		player.set_grid_position(get_start_position())

func get_start_position() -> Vector2i:
	return Vector2i() if not spawnPoint else PathFinder.local_to_point(spawnPoint.position)

