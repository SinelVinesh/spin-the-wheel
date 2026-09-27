class_name FiniteStateMachine extends Node

@export var initial_state: State
@export var id: FSMConstants.ID
var _current: State
var states: Dictionary[int,State]


func _ready():
	print_debug("[State Machine] State Machine initialized")
	_initialize_states()
	_current = initial_state
	_current.enter()
	EventBus.state_change_requested.connect(_on_transition_to_state)


func _initialize_states():
	states = {}
	for state in get_children():
		if state is State:
			states[state.state_id] = state


func transition_to_state(state_id: int):
	_on_transition_to_state(id, state_id)

func _on_transition_to_state(state_machine_id: FSMConstants.ID, state_id: int):
	print("StateMachine: Transition to state %d" % state_id)
	if state_machine_id != id or state_id == _current.state_id:
		return
	if not states.has(state_id):
		push_error("StateMachine: State %s not found in states dictionary." % str(state_id))
		
	_current.exit()
	_current = states[state_id]
	_current.enter()
	
func get_current_state_key() -> int:
	if _current == null:
		return -1
	return states.find_key(_current)
