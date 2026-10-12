extends Node

const DEFAULT_SPIN_POINTS: int = 0
const DEFAULT_SPIN_MULTIPLIER: int = 1

var current_wheel_state: FSMWheelConstants.Wheel = FSMWheelConstants.Wheel.IDLE
var points: int = 0
var free_spins: int = 0

var spin_points: int = DEFAULT_SPIN_POINTS
var spin_multiplier: int = DEFAULT_SPIN_MULTIPLIER


func _ready() -> void:
	EventBus.wheel_state_changed.connect(_on_wheel_state_changed)
	EventBus.spin_result_computation_requested.connect(_on_spin_result_computation_requested)
	EventBus.spin_points_update_requested.connect(_on_spin_points_update_requested)
	EventBus.spin_multiplier_update_requested.connect(_on_spin_multiplier_update_requested)
	EventBus.free_spin_counter_update_requested.connect(_on_spin_free_spin_update_requested)

func _on_wheel_state_changed(_old, new_state) -> void:
	current_wheel_state = new_state

func is_wheel_idle() -> bool:
	return current_wheel_state == FSMWheelConstants.Wheel.IDLE

func is_wheel_spinning() -> bool:
	return current_wheel_state == FSMWheelConstants.Wheel.SPINNING

func _on_spin_result_computation_requested() -> void:
	points += spin_points * spin_multiplier
	spin_points = DEFAULT_SPIN_POINTS
	spin_multiplier = DEFAULT_SPIN_MULTIPLIER
	EventBus.points_updated.emit()

func is_drag_and_drop_enabled() -> bool:
	return current_wheel_state == FSMWheelConstants.Wheel.IDLE

func _on_spin_points_update_requested(delta: int) -> void:
	spin_points += delta
	EventBus.spin_points_updated.emit()

func _on_spin_multiplier_update_requested(multiplier: int) -> void:
	spin_multiplier *= multiplier
	EventBus.spin_multiplier_updated.emit()

func _on_spin_free_spin_update_requested(free_spin: int) -> void:
	free_spins += free_spin
	EventBus.free_spin_counter_updated.emit()

func apply_free_spin() -> bool:
	if free_spins > 0:
		free_spins -= 1
		EventBus.free_spin_counter_updated.emit()
		return true
	return false