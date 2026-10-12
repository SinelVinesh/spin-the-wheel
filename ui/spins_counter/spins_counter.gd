extends Label

const TEXT_FORMAT = "Spins: %d"

func _ready() -> void:
	_refresh_text()
	EventBus.remaining_spins_updated.connect(_refresh_text)

func _refresh_text() -> void:
	text = TEXT_FORMAT % GameState.remaining_spins
