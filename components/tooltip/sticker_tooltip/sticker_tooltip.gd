class_name StickerTooltip extends Node

const OFFSET_BELOW_STICKER := Vector2(0.0, 40.0)
const STICKER_COLLISION_MASK := 4
const TITLE_FORMAT = "[%s] %s"

@onready var _show_timer: Timer = $ShowTimer

var _sticker: Sticker
var _draggable: Draggable
var _is_showing := false

func _ready() -> void:
	_sticker = get_parent() as Sticker
	if _sticker == null:
		print_debug("[StickerTooltip] parent is not a Sticker.")
		return
	_draggable = Components.get_component(_sticker, Draggable)
	_sticker.mouse_entered.connect(_on_mouse_entered)
	_sticker.mouse_exited.connect(_dismiss)
	_show_timer.timeout.connect(_on_show_timer_timeout)
	if _draggable != null:
		_draggable.drag_started.connect(_dismiss)
	EventBus.wheel_state_changed.connect(_on_wheel_state_changed)

func _exit_tree() -> void:
	_dismiss()

func _on_mouse_entered() -> void:
	if _can_start_hover():
		_show_timer.start()

func _on_wheel_state_changed(_old, new_state) -> void:
	if new_state == FSMWheelConstants.Wheel.SPINNING:
		_dismiss()

func _on_show_timer_timeout() -> void:
	if not _can_show():
		return
	_is_showing = true
	var info := _sticker.sticker_info
	EventBus.tooltip_show_requested.emit(TITLE_FORMAT % [StickerConstants.RarityName[info.rarity], info.name], info.description, _get_anchor())

func _dismiss() -> void:
	_show_timer.stop()
	if not _is_showing:
		return
	_is_showing = false
	EventBus.tooltip_hide_requested.emit()

func _can_start_hover() -> bool:
	return _sticker.sticker_info != null and not GameState.is_wheel_spinning() and not _is_dragged()

func _can_show() -> bool:
	return _can_start_hover() and _find_topmost_sticker_under_cursor() == _sticker

func _is_dragged() -> bool:
	return _draggable != null and _draggable.is_dragging()

func _get_anchor() -> Vector2:
	return _sticker.get_global_transform_with_canvas().origin + OFFSET_BELOW_STICKER

func _find_topmost_sticker_under_cursor() -> Sticker:
	var query := PhysicsPointQueryParameters2D.new()
	query.position = _sticker.get_global_mouse_position()
	query.collision_mask = STICKER_COLLISION_MASK
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var topmost: Sticker = null
	for hit in _sticker.get_world_2d().direct_space_state.intersect_point(query):
		var candidate := hit.collider as Sticker
		if candidate != null and (topmost == null or candidate.is_greater_than(topmost)):
			topmost = candidate
	return topmost
