class_name Strings
extends Node

## all_char_in_set checks that all character of the string a is in the set b
static func all_char_in_set(a: String, b: String) -> bool:
	for c in a:
		if c not in b:
			return false
	return true
