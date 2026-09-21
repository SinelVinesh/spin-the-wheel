extends Node2D

@export var debugMode: bool
@export var debugContext: RunContext

func _ready() -> void:
	if debugMode:
		EventBus.run_init_requested.emit(debugContext)
	else:
		EventBus.run_init_requested.emit(null)
