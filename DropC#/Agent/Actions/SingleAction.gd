class_name SelfAction
extends Action

var target: Agent

func _init(targ: Agent, block: bool, should_add: bool):
	super._init(block, should_add)
	target = targ

func set_target(agent: Agent) -> bool: 
	target = agent
	return true		
