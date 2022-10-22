extends CanvasLayer

@export_range(0, 25, 1) var _num_labels: int

enum LAYER{
	HIGHLIGHT=1
}

var _target_agent: Agent
var _label: RichTextLabel
var _lines: Array[String]
var _debug_map: TileMap
var tile_dict: Dictionary
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	# Set up labels
	_label = $PanelContainer/RichTextLabel as RichTextLabel
	_label.clear()
	PathFinder.map_swapped.connect(set_map)

func set_map(map: TileMap) -> void:
	_debug_map = PathFinder.map

func set_agent(agent: Agent) -> void:
	if _target_agent:
		_target_agent.action_declared.disconnect(_push_action)
	_target_agent = agent
	_target_agent.action_declared.connect(_push_action)

func clear_actions() -> void:
	tile_dict.clear()
	_debug_map.clear_layer(1)
	pass

# Connected to the target agent's start action method. Adds the line to array
func _push_action(action: Action) -> void:
	action.started.connect(log_action.bind(action.debug_string()))
	action.started.connect(_update_action_highlights.bind(action))
	action.finished.connect(_update_action_highlights.bind(action))
	for cell in action.affected_cells:
		if not tile_dict.has(cell):
			tile_dict[cell] = []
		tile_dict[cell].push_back(action)
	_update_action_highlights(action)

func _update_action_highlights(action: Action) -> void:
	var cells = action.affected_cells
	for cell in cells:
		if not tile_dict.has(cell): tile_dict[cell] = []
	_update_cells(cells)

func _update_cells(cells: Array[Vector2i]) -> void:
	for cell in cells:
		if not tile_dict.has(cell) or tile_dict[cell].size() <= 0:
			_debug_map.erase_cell(1, cell)
			continue
		var highest_in_cell = Vector2i.ZERO
		for action in (tile_dict[cell] as Array[Action]):
			var c = action.marker_coords.x + action.marker_coords.y * 2
			if c > highest_in_cell.x + highest_in_cell.y * 2:
				highest_in_cell = action.marker_coords
		_debug_map.set_cell(1, cell, 1, highest_in_cell)

func log_action(text: String):
	_label.append_text("\n" + text)

###
# Signal Hook ins
###
func _on_player_controller_turn_started() -> void:
	clear_actions()
