extends Node

class_name Jogador

signal ATUALIZAR_ATRIBUTOS_GUI
signal ATUALIZAR_INVENTARIOS_GUI
signal COMPRA_REALIZADA

@onready var jogadorGUIRef: JogadorGUI = $"../Jogador_GUI"

var nome: String = "Maritaca"
var almas: int = 0
var dinheiro: int = 2000
var fama: float = 0.1
var inventarioMaquinas: Array[MaquinaData]
var inventarioFuncionarios: Array[FuncionarioData]
var inventarioUpgrades = []

var screenSize

func _ready():
	screenSize = get_viewport().get_visible_rect().size
	pass

func definir_Nome(novoNome: String):
	nome = novoNome
	ATUALIZAR_ATRIBUTOS_GUI.emit()
	return nome

func alterar_dinheiro(novoValor: int):
	dinheiro += novoValor
	ATUALIZAR_ATRIBUTOS_GUI.emit()
	return dinheiro

func alterar_fama(novoValor: float):
	fama += novoValor
	ATUALIZAR_ATRIBUTOS_GUI.emit()
	return fama

func alterar_almas(novoValor: int):
	almas += novoValor
	ATUALIZAR_ATRIBUTOS_GUI.emit()
	return almas

func consultar_saldo_para_compra(itemSolicitado: Resource):
	if itemSolicitado.preco <= dinheiro:
		adicionar_ao_inventario(itemSolicitado)
		alterar_dinheiro(-itemSolicitado.preco)
		COMPRA_REALIZADA.emit(itemSolicitado)
	else:
		print("SALDO INSUFICIENTE")

func adicionar_ao_inventario(itemRecebido: Resource):
	if itemRecebido == null:
		push_warning("Item recebido tipo NULL!")
	elif itemRecebido is FuncionarioData:
		inventarioFuncionarios.append(itemRecebido)
	elif MaquinaData:
		inventarioMaquinas.append(itemRecebido)
	ATUALIZAR_INVENTARIOS_GUI.emit()

func remover_do_inventario(itemSelecionado: Resource):
	if itemSelecionado == null:
		push_warning("Item selecionado tipo NULL!")
	elif itemSelecionado is FuncionarioData:
		inventarioFuncionarios.erase(itemSelecionado)
	elif itemSelecionado is MaquinaData:
		inventarioMaquinas.erase(itemSelecionado)
	ATUALIZAR_INVENTARIOS_GUI.emit()

func instanciar_objetos(dados: Resource):
	if dados == null:
		push_warning("Resource NULL")
	elif dados is FuncionarioData:
		remover_do_inventario(dados)
		return factory_funcionario(dados)
	elif dados is MaquinaData:
		remover_do_inventario(dados)
		return factory_maquina(dados)

func factory_funcionario(dados: FuncionarioData):
	var funcionario = preload("res://cenas/funcionario.tscn").instantiate()
	funcionario.name = dados.nome
	funcionario.MEDO_MAXIMO_ATINGIDO.connect(func (funcionario_atual):
		atualizar_dados(funcionario_atual) #feito por lorenzo(ja sabe ne)
		alterar_fama(-0.1))
	add_child(funcionario)
	funcionario.setup(dados)
	funcionario.global_position = Vector2(screenSize[0]/2, screenSize[1]/2)
	return funcionario

func factory_maquina(dados: MaquinaData):
	var maquina = preload("res://cenas/maquina.tscn").instantiate()
	maquina.name = dados.nome
	maquina.FUNCIONARIO_MORREU_NA_MAQUINA.connect(func (funcionario, renda): 
		_deletar_funcionario(funcionario) 
		alterar_dinheiro(renda))
	maquina.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.connect(func (renda, funcionario):
		alterar_dinheiro(renda)
		funcionario.atualizarMedo())
	add_child(maquina)
	maquina.inicializar(dados)
	maquina.global_position = Vector2(screenSize[0] / 2, screenSize[1] / 2)
	return maquina

func _deletar_funcionario(funcionario: Funcionario):
	var sprite : Sprite2D 
	var animation : AnimatedSprite2D
	animation = funcionario.get_child(1)
	sprite = funcionario.get_child(0)
	sprite.visible = false
	animation.visible = true
	animation.play("morte")
	animation.animation_finished.connect(func():deletar_funcionario(funcionario))

func deletar_funcionario(funcionario: Funcionario):
	alterar_almas(+1)
	funcionario.queue_free()


func atualizar_dados(funcionario: Funcionario):
	funcionario.queue_free()
