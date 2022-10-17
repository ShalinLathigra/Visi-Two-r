class_name GroupAction
extends Action

var targets: Array[Agent]

func add_target(agent: Agent) -> bool: 
	if targets.has(agent): return false
	targets.push_back(agent)
	return true
