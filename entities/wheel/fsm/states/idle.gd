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
	print_debug("[Wheel][Idle State] Spin requested")
	fsm.transition_to_state(FSMWheelConstants.Wheel.SPINNING)

func enter():
	EventBus.wheel_spin_requested.connect(_request_spin, CONNECT_ONE_SHOT)

func exit():
	if EventBus.wheel_spin_requested.is_connected(_request_spin):
		EventBus.wheel_spin_requested.disconnect(_request_spin)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("spin"):
		_request_spin()
