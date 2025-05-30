extends Node2D

var objetoArrastado
var screenSize
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	arrastar_objeto()
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var objetoAlvo = raycast(1)
			if objetoAlvo is Funcionario:
				print("É um Funcionario")
				objetoArrastado = objetoAlvo
		if event.is_released():
			var objetoAlvo = raycast(2)
			if objetoAlvo is Maquina:
				print("Maquina")
				if objetoArrastado is Funcionario:
					objetoAlvo.adicionarFuncionario(objetoArrastado)
					resetar_objeto_arrastado()
			else:
				resetar_objeto_arrastado()

func raycast(mask_id: int):
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = mask_id
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		print(result[0])
		return result[0].collider.get_parent()
	return null

func arrastar_objeto():
	if objetoArrastado:
		var mousePos = get_global_mouse_position()
		objetoArrastado.global_position = mousePos
	pass

func resetar_objeto_arrastado():
	objetoArrastado = null
