class_name UpdateMultiplier
extends Effect

@export var multiplier: int

func apply() -> void:
	EventBus.spin_multiplier_update_requested.emit(multiplier)
