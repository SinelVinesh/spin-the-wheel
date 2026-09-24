@tool
extends Node2D

@export var section_type: SectionTypeInfo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if section_type != null:
		if section_type.weight == 0:
			section_type.weight = section_type.initial_weight
		%Sprite2D.modulate = section_type.color
		%Label.text = section_type.name
		_update_label()
	print("Weight: %s, Initial Weight: %s" % [section_type.weight, section_type.initial_weight])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		%Sprite2D.modulate = section_type.color
		_update_shader_weight()
		_update_collision_shape()
		_update_label()
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

func _update_label() -> void:
	if section_type != null:
		# Rotation and position
		var angle = section_type.weight / 2 * PI/180
		var label_x_offset = -%Sprite2D.texture.get_height() / 4
		var label_y_offset = %Label.get_size().y / 2
		%Label.pivot_offset = Vector2(label_x_offset, label_y_offset)
		%Label.rotation = -(PI/2) + angle
		%Label.position = Vector2(-label_x_offset,-label_y_offset)

		# Font size
		var font_size = 16
		if section_type.weight < 20:
			font_size = 16 * section_type.weight / 20
		%Label.add_theme_font_size_override("font_size", font_size)
		# Reset size
		%Label.size = Vector2.ZERO
	
