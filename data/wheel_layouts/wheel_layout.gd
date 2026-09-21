class_name WheelLayoutInfo
extends Resource

@export var name: String
@export var sections: Array[SectionTypeInfo]

func _init():
	if sections != null:
		_init_weights()
		
func _init_weights():
	for section in sections:
		section.weight = section.initial_weight
