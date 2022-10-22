extends Node2D

signal map_swapped

var grid : AStarGrid2D

@export var map : TileMap

enum LAYER {
	BASE,
	HIGHLIGHT,
}

func _ready() -> void:
	set_map(map)

func set_map(m: TileMap) -> void:
	map = m
	grid = AStarGrid2D.new();
	grid.default_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grid.size = map.get_used_rect().size
	grid.offset = map.get_used_rect().position
	grid.cell_size = map.tile_set.tile_size
	grid.update()

	for cell in map.get_used_cells(0):
		var tile = map.get_cell_tile_data(0, cell)
		grid.set_point_solid(cell, not tile.get_custom_data("Walkable"))

	emit_signal("map_swapped", map)

func find_point_path(start: Vector2i, end: Vector2i) -> Array[Vector2i]:
	return grid.get_id_path(start, end)

func is_point_solid(point: Vector2i) -> bool:
	return grid.is_point_solid(point)

func local_to_point(local: Vector2) -> Vector2i:
	return map.local_to_map(local)

func point_to_local(point: Vector2i) -> Vector2:
	return map.map_to_local(point)
