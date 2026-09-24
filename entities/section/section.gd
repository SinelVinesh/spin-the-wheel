@tool
extends Node2D

@export var section_type: SectionTypeInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if section_type != null:
		if section_type.weight == 0:
			section_type.weight = section_type.initial_weight
		%Sprite2D.modulate = section_type.color
	print("Weight: %s, Initial Weight: %s" % [section_type.weight, section_type.initial_weight])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		%Sprite2D.modulate = section_type.color
		_update_shader_weight()
		_update_collision_shape()
	pass

func _update_shader_weight() -> void:
	if section_type != null:
		%Sprite2D.material.set_shader_parameter("weight", section_type.weight)

func _update_collision_shape() -> void:
	if section_type != null:
		var polygons: Array[Vector2] = [Vector2(0,0)]
		var radius = %Sprite2D.texture.get_height() / 2 + 1
		for i in range(0,section_type.weight,4):
			var angle = i * PI/180
			var x = radius * cos(angle)
			var y = radius * sin(angle)
			polygons.append(Vector2(y,-x))
		# Add last point to close the polygon
		var angle = section_type.weight * PI/180
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		polygons.append(Vector2(y,-x))
		%Collision.set_polygon(polygons)
