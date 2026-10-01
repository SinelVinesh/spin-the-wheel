extends Node

var current_wheel_state: FSMWheelConstants.Wheel = FSMWheelConstants.Wheel.IDLE

func _ready() -> void:
	EventBus.wheel_state_changed.connect(_on_wheel_state_changed)

func _on_wheel_state_changed(_old, new_state) -> void:
	current_wheel_state = new_state

func is_wheel_idle() -> bool:
	return current_wheel_state == FSMWheelConstants.Wheel.IDLE
