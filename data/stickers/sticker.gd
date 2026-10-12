class_name StickerInfo
extends Resource

@export var name: String
@export var image: Texture2D
@export_multiline var description: String
@export var effect: Effect

func trigger() -> void:
	print_debug("Sticker triggered: %s" % name)
	if effect != null:
		effect.apply()
