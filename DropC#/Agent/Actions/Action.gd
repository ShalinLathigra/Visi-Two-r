class_name Action
extends RefCounted

var _blocking: bool
var should_add_to_queue: bool
var used: bool
var name: StringName

func _init(block: bool = false, should_add: bool = false):
	_blocking = block
	should_add_to_queue = should_add
	used = false
	name = "Action"
	
func invoke() -> void:
	used = true
	pass

