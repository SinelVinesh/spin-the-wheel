extends CanvasLayer

const SEED = "SEED"

var _label_mapping: Dictionary[String,Label] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.seed_updated.connect(_update_seed)

func create_debug_line(title: String, data: Variant) -> void:
	var container = HBoxContainer.new()
	var title_label = Label.new()
	var data_label = Label.new()

	title_label.text = title + ": "
	data_label.text = str(data)
	container.add_child(title_label)
	container.add_child(data_label)
	%LogWindow.add_child(container)
	_label_mapping[title] = data_label

func _initialize() -> void:
	create_debug_line(SEED, RandomManager.game_seed)

func _update_seed() -> void:
	if SEED in _label_mapping:
		_label_mapping[SEED].text = RandomManager.game_seed
	else:
		create_debug_line(SEED, RandomManager.game_seed)
