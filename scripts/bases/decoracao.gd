extends Node2D

class_name Decoracao

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func _ready():
	set_process(true)
	print("Decoracao _ready chamado!")
	
	# Conecta input_event da Area2D
	if has_node("Area2D"):
		var area = get_node("Area2D")
		print("Area2D encontrada, conectando input_event")
		area.input_event.connect(_on_area_input_event)
	else:
		print("ERRO: Area2D não encontrada!")

func _on_area_input_event(_viewport, event, _shape_idx):
	print("Input event recebido: ", event)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print("Mouse button LEFT, pressed: ", event.pressed)
		if event.pressed:
			is_dragging = true
			drag_offset = global_position - get_viewport().get_mouse_position()
			print("Iniciou drag em ", global_position)
			if has_meta("sprite_ref"):
				get_meta("sprite_ref").modulate = Color(1, 1, 0.5, 0.8)
		else:
			is_dragging = false
			print("Finalizou drag em ", global_position)
			if has_meta("sprite_ref"):
				get_meta("sprite_ref").modulate = Color(1, 1, 1, 0.9)

func _process(_delta):
	if is_dragging:
		var new_pos = get_viewport().get_mouse_position() + drag_offset
		global_position = new_pos
		#print("Arrastando para: ", new_pos)
