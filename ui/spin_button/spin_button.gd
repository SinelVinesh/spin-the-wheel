extends Button

func _ready() -> void:
	disabled = !GameState.is_wheel_idle()
	EventBus.wheel_state_changed.connect(_on_wheel_state_changed)

func _on_pressed():
	EventBus.wheel_spin_requested.emit()

func _on_wheel_state_changed(_old_state,_new_state):
	disabled = !GameState.is_wheel_idle()
