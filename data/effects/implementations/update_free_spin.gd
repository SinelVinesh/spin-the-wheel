class_name UpdateFreeSpin
extends Effect

@export var amount: int

func apply() -> void:
	EventBus.free_spin_counter_update_requested.emit(amount)
