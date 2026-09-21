extends Node

const SEED_LENGTH = 10
const VALID_CHARACTERS = "abcdefghijklmnopqrstuvwxyz0123456789"

var game_seed: String
var rng = RandomNumberGenerator.new() 

func _ready() -> void:
	EventBus.run_init_requested.connect(_init_seed)
	
func _init_seed(context: RunContext):
	game_seed = context.game_seed
	if !_valid_seed():
		print_debug("Invalid seed '%s' provided. Generating a new seed." % game_seed)
		_generate_seed()
	rng.seed = hash(game_seed)
	EventBus.seed_updated.emit()
	
func _valid_seed() -> bool:
	if len(game_seed) != SEED_LENGTH:
		return false
	if !Strings.all_char_in_set(game_seed, VALID_CHARACTERS):
		return false
	return true
	
func _generate_seed():
	game_seed = ""
	var n_char = len(VALID_CHARACTERS)
	for i in range(10):
		game_seed += VALID_CHARACTERS[randi()% n_char]
