extends Button

func _ready() -> void:
	_refresh_disabled()
	EventBus.wheel_state_changed.connect(_on_wheel_state_changed)
	EventBus.remaining_spins_updated.connect(_refresh_disabled)

func _on_pressed():
	EventBus.wheel_spin_requested.emit()

func _on_wheel_state_changed(_old_state,_new_state):
	_refresh_disabled()

func _refresh_disabled() -> void:
	disabled = !GameState.is_wheel_idle() or !GameState.has_remaining_spins()
