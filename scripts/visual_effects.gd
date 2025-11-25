extends Node

# Cria um efeito de partículas temporário em uma posição
static func create_upgrade_particles(parent: Node, position: Vector2, color: Color = Color.GOLD):
	var particles = CPUParticles2D.new()
	particles.position = position
	particles.emitting = true
	particles.one_shot = true
	particles.amount = 20
	particles.lifetime = 0.8
	particles.explosiveness = 0.8
	
	# Configurações visuais
	particles.color = color
	particles.color_ramp = create_color_gradient(color)
	particles.direction = Vector2(0, -1)
	particles.spread = 180
	particles.gravity = Vector2(0, 200)
	particles.initial_velocity_min = 100
	particles.initial_velocity_max = 200
	particles.scale_amount_min = 2
	particles.scale_amount_max = 4
	
	parent.add_child(particles)
	
	# Remove após terminar
	await parent.get_tree().create_timer(1.0).timeout
	if is_instance_valid(particles):
		particles.queue_free()

static func create_color_gradient(base_color: Color) -> Gradient:
	var gradient = Gradient.new()
	# Cria um gradiente baseado na cor fornecida
	var bright_color = base_color * 1.5
	bright_color.a = 1.0
	var mid_color = base_color
	mid_color.a = 0.5
	var fade_color = base_color * 0.5
	fade_color.a = 0.0
	
	gradient.colors = PackedColorArray([bright_color, mid_color, fade_color])
	gradient.offsets = PackedFloat32Array([0.0, 0.5, 1.0])
	return gradient

# Efeito de flash em um nó
static func flash_node(node: Node, color: Color = Color.WHITE, duration: float = 0.3):
	if not node is CanvasItem:
		return
	
	var original_modulate = node.modulate
	var tween = node.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(node, "modulate", color, duration / 2)
	tween.tween_property(node, "modulate", original_modulate, duration / 2)

# Efeito de pulso em um nó
static func pulse_node(node: Node, scale_multiplier: float = 1.3, duration: float = 0.4):
	if not node is Node2D and not node is Control:
		return
	
	var original_scale = node.scale
	var tween = node.create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(node, "scale", original_scale * scale_multiplier, duration / 2)
	tween.tween_property(node, "scale", original_scale, duration / 2)
