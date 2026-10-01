class_name Stopped
extends State

var wheel: Wheel

func _init():
	state_id = FSMWheelConstants.Wheel.STOPPED

func enter():
	if wheel == null:
		push_error("[Wheel][Stopped State] Wheel reference is null.")
		return
	wheel.compute_result()
	fsm.transition_to_state(FSMWheelConstants.Wheel.IDLE)
