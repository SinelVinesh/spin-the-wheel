class_name FiniteStateMachine extends Node

@export var initial_state: State
@export var id: FSMConstants.ID
var _current: State
var states: Dictionary[int,State]
var _state_changed_signal: Signal

func _ready():
	print_debug("[State Machine] State Machine initialized")
	_initialize_states()
	if initial_state == null:
		push_error("State Machine: Initial state is not set.")
		return
	_current = initial_state
	print_debug("[%s][%s State] Entering" % [FSMConstants.ID.find_key(id), str(_current.name)])
	_current.enter()

func _initialize_states():
	states = {}
	for state in get_children():
		if state is State:
			states[state.state_id] = state
			state.fsm = self
			_per_state_additional_setup(state)

func _per_state_additional_setup(state: State):
	pass

func _unhandled_input(event: InputEvent) -> void:
	if _current != null:
		_current.handle_input(event)

func transition_to_state(state_id: int):
	_on_transition_to_state(id, state_id)

func _on_transition_to_state(state_machine_id: FSMConstants.ID, state_id: int):
	if state_machine_id != id or state_id == _current.state_id:
		return
	print_debug("StateMachine: Transition to state %d" % state_id)
	if not states.has(state_id):
		push_error("StateMachine: State %s not found in states dictionary." % str(state_id))
		return
	
	var old_state_id = _current.state_id
	_current.exit()
	print_debug("[%s][%s State] Exiting" % [FSMConstants.ID.find_key(id), str(_current.name)])
	_current = states[state_id]
	print_debug("[%s][%s State] Entering" % [FSMConstants.ID.find_key(id), str(_current.name)])
	if _state_changed_signal != null:
		_state_changed_signal.emit(old_state_id,state_id)
	_current.enter()
	
	
func get_current_state_key() -> int:
	if _current == null:
		return -1
	return states.find_key(_current)
