extends CanvasLayer

const SEED = "SEED"
const POINTS = "POINTS"
const FREE_SPINS = "FREE_SPINS"
const SPIN_POINTS = "SPIN_POINTS"
const SPIN_MULTIPLIER = "SPIN_MULTIPLIER"

var _label_mapping: Dictionary[String,Label] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.seed_updated.connect(_update_seed)
	EventBus.points_updated.connect(_update_points)
	EventBus.spin_points_updated.connect(_update_spin_points)
	EventBus.spin_multiplier_updated.connect(_update_spin_multiplier)
	EventBus.free_spin_counter_updated.connect(_update_free_spins)
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

func _update_seed() -> void:
	if SEED in _label_mapping:
		_label_mapping[SEED].text = RandomManager.game_seed
	else:
		create_debug_line(SEED, RandomManager.game_seed)

func _update_points() -> void:
	if POINTS in _label_mapping:
		_label_mapping[POINTS].text = str(GameState.points)
	else:
		create_debug_line(POINTS, GameState.points)

func _update_spin_points() -> void:
	if SPIN_POINTS in _label_mapping:
		_label_mapping[SPIN_POINTS].text = str(GameState.spin_points)
	else:
		create_debug_line(SPIN_POINTS, GameState.spin_points)

func _update_spin_multiplier() -> void:
	if SPIN_MULTIPLIER in _label_mapping:
		_label_mapping[SPIN_MULTIPLIER].text = str(GameState.spin_multiplier)
	else:
		create_debug_line(SPIN_MULTIPLIER, GameState.spin_multiplier)

func _update_free_spins() -> void:
	if FREE_SPINS in _label_mapping:
		_label_mapping[FREE_SPINS].text = str(GameState.free_spins)
	else:
		create_debug_line(FREE_SPINS, GameState.free_spins)
