extends CanvasLayer

@export_range(0, 25, 1) var _num_labels: int

var labels: Array[Label]
var _label_container: VBoxContainer
# Called when the node enters the scene tree for the first time.

func _ready():
	# Set up labels
	_label_container = $PanelContainer/LabelContainer as VBoxContainer
	for i in range(_num_labels):
		var new_label = Label.new()
		labels.push_back(new_label)
		_label_container.add_child(new_label)
	labels.reverse()
	

func push_action(action: Action) -> void:
	var next_text: String = action.to_string()
	var swap: String
	for label in labels:
		swap = label.text
		label.text = next_text
		next_text = swap
