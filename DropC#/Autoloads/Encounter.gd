extends Node2D


# Player Game State
# Level Game State
# Spawn position marker

# State tree setup

@export var encounterMap: TileMap
@export var spawnPoint: Node2D


func _ready() -> void:
	start()

func start() -> void:
	if encounterMap: PathFinder.set_map(encounterMap)
