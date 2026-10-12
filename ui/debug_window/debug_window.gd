extends CanvasLayer

const SEED = "SEED"
const POINTS = "POINTS"
const FREE_SPINS = "FREE_SPINS"
const SPIN_POINTS = "SPIN_POINTS"
const SPIN_MULTIPLIER = "SPIN_MULTIPLIER"
const REMAINING_SPINS = "REMAINING_SPINS"

var _label_mapping: Dictionary[String,Label] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.seed_updated.connect(_update_seed)
	EventBus.points_updated.connect(_update_points)
	EventBus.spin_points_updated.connect(_update_spin_points)
	EventBus.spin_multiplier_updated.connect(_update_spin_multiplier)
	EventBus.free_spin_counter_updated.connect(_update_free_spins)
	EventBus.remaining_spins_updated.connect(_update_remaining_spins)
	_initialize()

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
	create_debug_line(POINTS, 0)
	create_debug_line(SPIN_POINTS, 0)
	create_debug_line(SPIN_MULTIPLIER, 1)
	create_debug_line(FREE_SPINS, 0)
	create_debug_line(REMAINING_SPINS, GameState.remaining_spins)

func _update_seed() -> void:
	_update_debug_line(SEED, RandomManager.game_seed)

func _update_points() -> void:
	_update_debug_line(POINTS, GameState.points)

func _update_spin_points() -> void:
	_update_debug_line(SPIN_POINTS, GameState.spin_points)

func _update_spin_multiplier() -> void:
	_update_debug_line(SPIN_MULTIPLIER, GameState.spin_multiplier)

func _update_free_spins() -> void:
	_update_debug_line(FREE_SPINS, GameState.free_spins)

func _update_remaining_spins() -> void:
	_update_debug_line(REMAINING_SPINS, GameState.remaining_spins)

func _update_debug_line(title: String, data: Variant) -> void:
	if title in _label_mapping:
		_label_mapping[title].text = str(data)
	else:
		create_debug_line(title, data)
