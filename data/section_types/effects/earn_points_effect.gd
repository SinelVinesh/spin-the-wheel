class_name EarnPointsEffect
extends SectionTypeEffect

@export var points: int

func apply() -> void:
	EventBus.points_earned.emit(points)
