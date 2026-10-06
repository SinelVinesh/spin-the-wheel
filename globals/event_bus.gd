extends Node

@warning_ignore_start("unused_signal")

# State change signals
signal state_change_requested(state_machine_id: int, state_id: int)
signal wheel_state_changed(old_state: FSMWheelConstants.Wheel, new_state: FSMWheelConstants.Wheel)

# Run signals
signal run_init_requested(context: RunContext)
signal seed_updated()

# Points signal
signal points_update_requested(delta: int)
signal points_updated()

# Wheel signals
signal wheel_spin_requested()
signal wheel_spin_ended()

# Section signals
signal section_picked(section_type: Section)
