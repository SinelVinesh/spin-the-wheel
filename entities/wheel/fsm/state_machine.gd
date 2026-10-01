extends FiniteStateMachine

var _wheel: Wheel

func _ready():
	var parent = get_parent()
	if parent is Wheel:
		_wheel = parent as Wheel
	else:
		push_error("Wheel State Machine must be a child of a Wheel node.")
	super._ready()

func _per_state_additional_setup(state: State):
	if "wheel" in state:
		state.wheel = _wheel
