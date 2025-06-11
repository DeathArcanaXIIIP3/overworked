extends Control

var viewport
var screenSize

var temp

var maquinaRef : Maquina
var funcionarioRef : Funcionario
var jogadorGUIRef : JogadorGUI
var jogadorRef : Jogador

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	viewport = get_viewport_rect()
	screenSize = viewport.size
	
	jogadorGUIRef = factory_jogador_GUI()
	jogadorRef = factory_player()
	
	jogadorGUIRef.jogadorRef = jogadorRef
	
	add_child(jogadorGUIRef)
	add_child(jogadorRef)
	pass # Replace with function body.

func factory_jogador_GUI():
	var jogadorgui = preload("res://cenas/jogador_gui.tscn").instantiate()
	return jogadorgui

func factory_funcionario(data: FuncionarioData):
	var funcionario = preload("res://cenas/funcionario.tscn").instantiate()
	add_child(funcionario)
	funcionario.setup(data)
	funcionario.global_position = Vector2(screenSize[0] / 2, screenSize[1] / 2)
	return funcionario

func factory_maquina(data: MaquinaData):
	var maquina = preload("res://cenas/maquina.tscn").instantiate()
	add_child(maquina)
	maquina.setup(data)
	maquina.global_position = Vector2(screenSize[0] / 2, screenSize[1] / 2)
	return maquina

func factory_player():
	var jogador = preload("res://cenas/jogador.tscn").instantiate()
	print(jogador.definir_Nome("Caio"))
	print(jogador.alterar_dinheiro(+200))
	print(jogador.alterar_almas(+10))
	print(jogador.alterar_fama(1.0))
	jogador.connect("JOGADOR_PRONTO", jogadorGUIRef.atualizar_GUI)
	jogador.connect("FUNCIONARIO_ADICIONADO_AO_INVENTARIO", jogadorGUIRef.atualizar_inventario_GUI)
	return jogador

func _on_button_pressed() -> void:
	if maquinaRef:
		maquinaRef.queue_free()
	maquinaRef = factory_maquina(preload("res://resources/maquinas/Maquina_De_Impressão.tres"))
	pass # Replace with function body.

func _on_button_2_pressed() -> void:
	if funcionarioRef:
		funcionarioRef.queue_free()
	funcionarioRef = factory_funcionario(preload("res://resources/funcionarios/Fulana.tres"))
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	if jogadorRef:
		if funcionarioRef:
			jogadorRef.adicionar_funcionario_inventario(funcionarioRef)
		else:
			print("Não a funcionarios")
	else:
		print("Jogador não inicializado")
	pass # Replace with function body.
