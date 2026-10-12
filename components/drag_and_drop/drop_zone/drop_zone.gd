class_name DropZone extends Node

@export var collision_object: CollisionObject2D
@export var container: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if collision_object == null:
		print_debug("[DropZone] collision_object is not assigned.")
		return
	if container == null:
		print_debug("[DropZone] container is not assigned.")
		return
