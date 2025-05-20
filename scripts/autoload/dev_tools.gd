extends Control

var viewport
var screenSize
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport = get_viewport_rect()
	screenSize = viewport.size
	pass # Replace with function body.

func _on_button_pressed() -> void:
	factory_maquina(preload("res://resources/maquinas/Maquina_De_Impressão.tres"))
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	factory_funcionario(preload("res://resources/funcionarios/Fulano.tres"))
	pass # Replace with function body.

func factory_funcionario(data: FuncionarioData):
	var funcionario = preload("res://cenas/funcionario.tscn").instantiate()
	add_child(funcionario)
	funcionario.inicializacao(data)
	funcionario.global_position = Vector2(screenSize[0] / 2, screenSize[1] / 2)

func factory_maquina(data: MaquinaData):
	var maquina = preload("res://cenas/maquina.tscn").instantiate()
	add_child(maquina)
	maquina.setup(data)
	maquina.global_position = Vector2(screenSize[0] / 2, screenSize[1] / 2)
