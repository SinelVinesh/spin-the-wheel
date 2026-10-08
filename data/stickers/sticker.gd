class_name StickerInfo
extends Resource

@export var name: String
@export var image: Texture2D
@export_multiline var description: String
@export var effect: StickerEffect

func trigger() -> void:
	if effect != null:
		effect.apply()
