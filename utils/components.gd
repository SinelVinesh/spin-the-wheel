class_name Components extends RefCounted

static func has_component(node: Node, type: Script) -> bool:
	for child in node.get_children():
		if is_instance_of(child, type):
			return true
	return false

static func get_component(node: Node, type: Script) -> Node:
	for child in node.get_children():
		if is_instance_of(child, type):
			return child
	return null
