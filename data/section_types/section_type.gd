class_name SectionTypeInfo
extends Resource

@export var name: String
@export var color: Color
@export_multiline var description: String
@export var effect: SectionTypeEffect
## Initial size and probability for the section to be selected.
## (arbitrary value)
@export var initial_weight: float
## Runtime size and probability for the section to be selected. (between 0 and 1)
var weight: float

func trigger() -> void:
	if effect != null:
		effect.apply()
