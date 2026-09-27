class_name Idle
extends State

var wheel: Wheel

func _init():
	state_id = FSMWheelConstants.Wheel.IDLE

func _request_spin() -> void:
	if wheel == null:
		push_error("[Wheel][Idle State] Wheel reference is null.")
		return
	wheel.spin()
	fsm.transition_to_state(FSMWheelConstants.Wheel.SPINNING)
	print_debug("[Wheel][Idle State] Spin requested")

func enter():
	EventBus.wheel_spin_requested.connect(_request_spin)

func exit():
	EventBus.wheel_spin_requested.disconnect(_request_spin)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("spin"):
		_request_spin()
