extends Control

var viewport
var screenSize

@onready var maquinaAtual
@onready var funcionarioAtual
@onready var jogadorAtual
@onready var jogadorGUI
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport = get_viewport_rect()
	screenSize = viewport.size
	
	jogadorAtual = factory_player()
	jogadorGUI  = factory_jogador_GUI()
	
	jogadorAtual.connect("JOGADOR_PRONTO", Callable(jogadorGUI, "atualizar_GUI"))
	add_child(jogadorAtual)
	
	jogadorAtual._teste()
	pass # Replace with function body.

func factory_jogador_GUI():
	var jogadorgui = preload("res://cenas/jogador_gui.tscn").instantiate()
	add_child(jogadorgui)
	return jogadorgui

func factory_funcionario(data: FuncionarioData):
	var funcionario = preload("res://cenas/funcionario.tscn").instantiate()
	add_child(funcionario)
	funcionario.setup(data)
	funcionario.global_position = Vector2(screenSize[0] / 2, screenSize[1] / 2)
	return funcionario

func factory_maquina(data: MaquinaData):
	var maquina = preload("res://cenas/maquina.tscn").instantiate()
	maquina.setup(data)
	add_child(maquina)
	maquina.global_position = Vector2(screenSize[0] / 2, screenSize[1] / 2)
	return maquina

func factory_player():
	var jogador = preload("res://cenas/jogador.tscn").instantiate()
	print(jogador.definir_Nome("Caio"))
	print(jogador.alterar_dinheiro(+200))
	print(jogador.alterar_almas(+10))
	print(jogador.alterar_fama(1.0))
	return jogador

func _on_button_pressed() -> void:
	maquinaAtual = factory_maquina(preload("res://resources/maquinas/Maquina_De_Impressão.tres"))
	pass # Replace with function body.

func _on_button_2_pressed() -> void:
	funcionarioAtual = factory_funcionario(preload("res://resources/funcionarios/Fulana.tres"))
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	jogadorAtual = factory_player()
	pass # Replace with function body.
