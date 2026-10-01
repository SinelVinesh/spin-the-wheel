@tool
class_name Wheel
extends Node2D

@export var layout: WheelLayoutInfo
@export var loop_wheel_render_in_editor: bool = true
# max speed of the wheel (radian / seconde)
@export var max_angular_speed = 2.0
# how many seconds it takes to reach max speed
@export var idle_to_max_speed_duration = 0.5
@export var max_speed_to_stop_duration = 1.0

const EDITOR_REFRESH_INTERVAL := 1.0

@onready var section_scene: PackedScene = preload("res://entities/section/section.tscn")
@onready var _friction = max_angular_speed / max_speed_to_stop_duration
@onready var _acceleration = max_angular_speed / idle_to_max_speed_duration

var _editor_refresh_elapsed := 0.0
var _spin: bool = false
var _spin_elapsed: float = 0.0
var _start_rotation: float = 0.0
var _max_angular_speed_duration: float = 0.0

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

func _physics_process(delta: float) -> void:
	if not _spin:
		return
	_spin_elapsed += delta
	var spin_total_duration := _get_spin_total_duration()
	var sampled_time := minf(_spin_elapsed, spin_total_duration)
	rotation = _start_rotation + _get_angle_travelled(sampled_time)
	if _spin_elapsed >= spin_total_duration:
		_end_spin(spin_total_duration)

func _end_spin(duration: float) -> void:
	print_debug("[Wheel] Spin ended, duration: %s seconds" % duration)
	_spin = false
	_spin_elapsed = 0.0
	EventBus.wheel_spin_ended.emit()

func _get_max_speed_end_time() -> float:
	return idle_to_max_speed_duration + _max_angular_speed_duration

func _get_spin_total_duration() -> float:
	return _get_max_speed_end_time() + max_speed_to_stop_duration

func _get_angle_travelled(time: float) -> float:
	var acceleration_angle = 0.5 * _acceleration * idle_to_max_speed_duration ** 2
	if time <= idle_to_max_speed_duration:
		return 0.5 * _acceleration * time ** 2
	var max_speed_angle = max_angular_speed * _max_angular_speed_duration
	if time <= _get_max_speed_end_time():
		return acceleration_angle + max_angular_speed * (time - idle_to_max_speed_duration)
	var braking_time := time - _get_max_speed_end_time()
	var braking_angle = max_angular_speed * braking_time - 0.5 * _friction * braking_time ** 2
	return acceleration_angle + max_speed_angle + braking_angle

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
		%Sections.add_child(instance)

func _clear_sections() -> void:
	for child in %Sections.get_children():
		child.free()

func _extract_initial_weights(section: SectionTypeInfo) -> float:
	if section == null:
		return 0.0
	return section.initial_weight

func spin() -> void:
	_max_angular_speed_duration = RandomManager.randf_range(0, 1)
	_start_rotation = rotation
	_spin_elapsed = 0.0
	_spin = true

func compute_result() -> void:
	print_debug("[Wheel] Computing result")
