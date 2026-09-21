class_name SectionTypeInfo
extends Resource

@export var name: String
@export_multiline var description: String
@export var effect: SectionTypeEffect

func trigger() -> void:
	effect.apply()
