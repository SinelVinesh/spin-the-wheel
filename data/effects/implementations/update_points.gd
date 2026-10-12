class_name UpdatePoints
extends Effect

@export var points: int

func apply() -> void:
	EventBus.spin_points_update_requested.emit(points)
