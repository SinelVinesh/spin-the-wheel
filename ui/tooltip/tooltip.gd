class_name Tooltip extends PanelContainer

@onready var _title: Label = %Title
@onready var _body: Label = %Body

func _ready() -> void:
	hide()
	EventBus.tooltip_show_requested.connect(_on_show_requested)
	EventBus.tooltip_hide_requested.connect(hide)

func _on_show_requested(title: String, body: String, anchor: Vector2) -> void:
	_title.text = title
	_body.text = body
	reset_size()
	position = _clamp_to_viewport(anchor - Vector2(size.x / 2.0, 0.0))
	show()

func _clamp_to_viewport(target: Vector2) -> Vector2:
	var max_position := get_viewport_rect().size - size
	return target.clamp(Vector2.ZERO, max_position.max(Vector2.ZERO))
