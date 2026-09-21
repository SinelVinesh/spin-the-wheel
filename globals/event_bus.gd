extends Node

@warning_ignore_start("unused_signal")

# Run signals
signal run_init_requested(context: RunContext)
signal seed_updated()

# Points signal
signal points_earned(points: int)
