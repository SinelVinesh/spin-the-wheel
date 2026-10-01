extends Node

@warning_ignore_start("unused_signal")

# State change signals
signal state_change_requested(state_machine_id: int, state_id: int)

# Run signals
signal run_init_requested(context: RunContext)
signal seed_updated()

# Points signal
signal points_earned(points: int)

# Wheel signals
signal wheel_spin_requested()
signal wheel_spin_ended()
