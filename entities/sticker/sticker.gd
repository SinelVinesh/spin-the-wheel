@tool
class_name Sticker extends Node2D

const EDITOR_REFRESH_INTERVAL := 1.0

@export var sticker_info: StickerInfo
@export var render_in_editor: bool = true

var _editor_refresh_elapsed := 0.0

func _ready() -> void:
	_render_sticker()

func _process(delta: float) -> void:
	if not render_in_editor || not Engine.is_editor_hint():
		return
	_editor_refresh_elapsed += delta
	if _editor_refresh_elapsed < EDITOR_REFRESH_INTERVAL:
		return
	_editor_refresh_elapsed = 0.0
	_render_sticker()

func _render_sticker() -> void:
	if sticker_info == null:
		return
	%Sprite2D.texture = sticker_info.image
