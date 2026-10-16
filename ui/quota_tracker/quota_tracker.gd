extends Label

const TEXT_FORMAT = "Goal: %d / %d"

func _ready() -> void:
	_refresh_text()
	EventBus.quota_updated.connect(_refresh_text)
	EventBus.points_updated.connect(_refresh_text)

func _refresh_text() -> void:
	text = TEXT_FORMAT % [GameState.points,GameState.quota]
