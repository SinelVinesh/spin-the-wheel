extends Node

@warning_ignore_start("unused_signal")

# State change signals
signal state_change_requested(state_machine_id: int, state_id: int)
signal wheel_state_changed(old_state: FSMWheelConstants.Wheel, new_state: FSMWheelConstants.Wheel)

# Run signals
signal run_init_requested(context: RunContext)
signal seed_updated()
signal quota_updated()

# Points signal
signal points_updated()
signal free_spin_counter_update_requested(delta: int)
signal free_spin_counter_updated()
signal remaining_spins_updated()

# Wheel signals
signal wheel_spin_requested()
signal wheel_spin_ended()

# Tooltip signals
signal tooltip_show_requested(title: String, body: String, anchor: Vector2)
signal tooltip_hide_requested()

# Section signals
signal section_picked(section_type: Section)

# Spin signals
signal spin_points_update_requested(delta: int)
signal spin_multiplier_update_requested(multiplier: int)
signal spin_points_updated()
signal spin_multiplier_updated()
signal spin_result_computation_requested()
signal free_spin_requested()