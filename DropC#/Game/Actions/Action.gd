class_name Action
extends RefCounted

signal started
signal finished

enum Type {Move}

var affected_cells: Array[Vector2i]
var marker_coords: Vector2i

var used: bool
var valid: bool
var source: Agent
var type: Type

func _init(src: Agent):
	source = src
	used = false

func execute() -> void:
	if used: return
	used = true

func debug_string():
	return "Action: %" % used
