class_name Spinning
extends State

func _init():
	state_id = FSMWheelConstants.Wheel.SPINNING

func _on_spin_ended():
	print_debug("[Wheel][Spinning State] Spin ended")
	fsm.transition_to_state(FSMWheelConstants.Wheel.STOPPED)

func enter():
	EventBus.wheel_spin_ended.connect(_on_spin_ended, CONNECT_ONE_SHOT)
