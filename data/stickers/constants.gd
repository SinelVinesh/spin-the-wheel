class_name StickerConstants
extends RefCounted

enum Rarity {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
	UNIQUE
}

static var RarityBasePrice: Dictionary[Rarity, int] = {
	Rarity.COMMON: 20,
	Rarity.RARE: 30,
	Rarity.EPIC: 50,
	Rarity.LEGENDARY: 90,
	Rarity.UNIQUE: 150
}

static var RarityName: Dictionary[Rarity, String] = {
	Rarity.COMMON: "Common",
	Rarity.RARE: "Rare",
	Rarity.EPIC: "Epic",
	Rarity.LEGENDARY: "Legendary",
	Rarity.UNIQUE: "Unique"
}
