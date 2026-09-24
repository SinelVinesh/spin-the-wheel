@tool
extends Node2D

@export var layout: WheelLayoutInfo
@export var loop_wheel_render_in_editor: bool = true

const EDITOR_REFRESH_INTERVAL := 1.0

@onready var section_scene: PackedScene = preload("res://entities/section/section.tscn")

var _editor_refresh_elapsed := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_weights()
	_render_wheel()
	set_process(Engine.is_editor_hint() && loop_wheel_render_in_editor)


func _process(delta: float) -> void:
	if not loop_wheel_render_in_editor:
		return
	_editor_refresh_elapsed += delta
	if _editor_refresh_elapsed < EDITOR_REFRESH_INTERVAL:
		return
	_editor_refresh_elapsed = 0.0
	_render_wheel()

func _init_weights():
	if layout == null:
		return
	var total_weight = layout.sections.map(_extract_initial_weights).reduce(Reducers.sum_float, 0.0)
	for section in layout.sections:
		section.weight = section.initial_weight / total_weight * 360.0

func _render_wheel() -> void:
	print("Rendering wheel")
	_clear_sections()
	if layout == null:
		return
	var section_types = layout.sections
	if section_types == null or section_types.size() == 0:
		return
	var angle_offset = 0.0
	for section_type in section_types:
		if section_type == null:
			continue
		var instance = section_scene.instantiate()
		instance.section_type = section_type
		instance.rotation = angle_offset
		angle_offset += section_type.weight * PI/180
		add_child(instance)

func _clear_sections() -> void:
	for child in get_children():
		child.free()

func _extract_initial_weights(section: SectionTypeInfo) -> float:
	if section == null:
		return 0.0
	return section.initial_weight
