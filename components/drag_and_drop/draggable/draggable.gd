class_name Draggable extends Node

const HOVER_SCALE := Vector2(1.1, 1.1)
static var _hovered_draggables: Array[Draggable] = []

var _parent: CollisionObject2D
var _is_mouse_over: bool = false
var _is_dragging: bool = false
var _draggable: bool = true
var _dropping: bool = false
var _initial_position: Vector2

func _ready() -> void:
	_parent = get_parent()
	if _parent == null:
		print_debug("[DragAndDropComponent] parent is not assigned.")
		return
	if _parent is not CollisionObject2D:
		print_debug("[DragAndDropComponent] parent is not a CollisionObject2D.")
		return
	_initial_position = _parent.position
	_parent.mouse_entered.connect(_on_mouse_entered)
	_parent.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	if not _draggable or not GameState.is_drag_and_drop_enabled():
		return
	_register_hover()

func _on_mouse_exited() -> void:
	if not _hovered_draggables.has(self):
		return
	_set_hovered(false)
	_unregister_hover()

func _exit_tree() -> void:
	_unregister_hover()

func _set_hovered(hovered: bool) -> void:
	_is_mouse_over = hovered
	var target_scale := HOVER_SCALE if hovered else Vector2.ONE
	var tween := get_tree().create_tween()
	tween.tween_property(_parent, "scale", target_scale, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _register_hover() -> void:
	if not _hovered_draggables.has(self):
		_hovered_draggables.append(self)
	_sort_hovered_by_topmost()
	_refresh_hover_state()

func _sort_hovered_by_topmost() -> void:
	_hovered_draggables.sort_custom(
		func(a: Draggable, b: Draggable) -> bool:
			return a._parent.is_greater_than(b._parent)
	)

func _refresh_hover_state() -> void:
	for i in range(_hovered_draggables.size()):
		_hovered_draggables[i]._set_hovered(i == 0)

func _unregister_hover() -> void:
	_hovered_draggables.erase(self)
	if _hovered_draggables.size() > 0:
		_hovered_draggables[0]._set_hovered(true)

func _unhandled_input(event: InputEvent) -> void:
	if not _can_start_drag() or not event.is_action_pressed("click"):
		return
	_is_dragging = true
	get_viewport().set_input_as_handled()

func _can_start_drag() -> bool:
	return _draggable and _is_mouse_over and not _is_dragging and GameState.is_drag_and_drop_enabled()

func _process(_delta: float) -> void:
	if not _draggable:
		return
	if not GameState.is_drag_and_drop_enabled():
		_drop_to_initial_position()
		return
	if _is_dragging and Input.is_action_pressed("click"):
		var mouse_position := get_viewport().get_mouse_position()
		_parent.global_position = mouse_position
	elif _is_dragging and Input.is_action_just_released("click"):
		var target_zone := _get_drop_zone_at(_parent.get_global_mouse_position())
		if target_zone != null:
			_is_dragging = false
			_unregister_hover()
			_dropping = true
			_draggable = false
			_animate_drop_to_zone()
			_parent.reparent(target_zone.container)
		else:
			_drop_to_initial_position()

func _get_drop_zone_at(position: Vector2) -> DropZone:
	var query := PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_areas = true
	query.collide_with_bodies = false
	var hits := _parent.get_world_2d().direct_space_state.intersect_point(query)
	for hit in hits:
		var drop_zone = Components.get_component(hit.collider, DropZone)
		if drop_zone != null:
			return drop_zone
	return null

func _animate_drop_to_zone() -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(_parent, "scale", Vector2(0.6, 0.6), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _drop_to_initial_position() -> void:
	_is_dragging = false
	_unregister_hover()
	_dropping = true
	_draggable = false

	var tween := get_tree().create_tween()
	tween.tween_property(_parent, "position", _initial_position, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(_parent, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(_on_animate_drop_to_initial_position_finished)

func _on_animate_drop_to_initial_position_finished() -> void:
	_dropping = false
	_draggable = true
