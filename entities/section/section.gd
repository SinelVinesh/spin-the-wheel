@tool
class_name Section extends Area2D

const HIGHLIGHT_MAX_SCALE: Vector2 = Vector2(1.1,1.1)
const HIGHLIGHT_SPEED: float = 0.8
const HIGHLIGHT_COLOR_MULTIPLIER: float = 1.2

@export var section_type: SectionTypeInfo
@export_tool_button("Highlight", "") var hightlight_section = _highlight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if section_type != null:
		if section_type.weight == 0:
			section_type.weight = section_type.initial_weight
		%Sprite2D.modulate = section_type.color
		_update_shader_weight()
		_update_collision_shape()
		%Label.text = "%s (%s)" % [section_type.name, section_type.description]
		_update_label()

func _process(_delta: float) -> void:
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
		var label_x_offset = -%Sprite2D.texture.get_height() / 6
		var label_y_offset = %Label.get_size().y / 2
		%Label.pivot_offset = Vector2(label_x_offset, label_y_offset)
		%Label.rotation = -(PI/2) + angle
		%Label.position = Vector2(-label_x_offset,-label_y_offset)

		# Font size
		var font_size = 14
		if section_type.weight < 20:
			font_size = 14 * section_type.weight / 20
		%Label.add_theme_font_size_override("font_size", font_size)
		# Reset size
		%Label.size = Vector2(%Sprite2D.texture.get_height()/4,0)
	
func set_collision(enabled: bool) -> void:
	%Collision.disabled = not enabled

func apply_effect() -> void:
	_highlight()
	if section_type != null:
		section_type.trigger()

func _highlight() -> void:
	print_debug("Highlighted")
	var tween = get_tree().create_tween()
	var base_scale = scale
	var base_modulate = modulate
	tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"scale",HIGHLIGHT_MAX_SCALE,HIGHLIGHT_SPEED/2)
	tween.parallel().tween_property(self,"modulate",self.modulate*HIGHLIGHT_COLOR_MULTIPLIER,HIGHLIGHT_SPEED/2)
	tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_property(self,"scale",base_scale,HIGHLIGHT_SPEED/2)
	tween.parallel().tween_property(self,"modulate",base_modulate,HIGHLIGHT_SPEED/2)
