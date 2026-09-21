class_name Strings
extends RefCounted

## all_char_in_set checks that all characters of a are in the b set
static func all_char_in_set(a: String, b: String) -> bool:
	for c in a:
		if c not in b:
			return false
	return true
