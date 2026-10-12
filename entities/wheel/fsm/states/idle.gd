class_name Idle
extends State

var wheel: Wheel

func _init():
	state_id = FSMWheelConstants.Wheel.IDLE

func _request_player_spin() -> void:
	if not GameState.has_remaining_spins():
		return
	GameState.consume_spin()
	_start_spin()

func _start_spin() -> void:
	if wheel == null:
		push_error("[Wheel][Idle State] Wheel reference is null.")
		return
	wheel.spin()
	print_debug("[Wheel][Idle State] Spin requested")
	fsm.transition_to_state(FSMWheelConstants.Wheel.SPINNING)

func enter():
	EventBus.wheel_spin_requested.connect(_request_player_spin, CONNECT_ONE_SHOT)
	if GameState.apply_free_spin():
		print_debug("[Wheel][Idle State] Free spin applied")
		_start_spin()

func exit():
	if EventBus.wheel_spin_requested.is_connected(_request_player_spin):
		EventBus.wheel_spin_requested.disconnect(_request_player_spin)

func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("spin"):
		_request_player_spin()
