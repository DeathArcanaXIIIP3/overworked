extends TabContainer

class_name Loja

signal BOTÃO_PRESSIONADO

var listaFuncionarios : Array[FuncionarioData]
var listaMaquinas : Array[MaquinaData]
@onready var jogadorRef = $"../../Jogador"

func _ready() -> void:
	adicionar_funcionario_loja(load("res://resources/funcionarios/Fulana.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Fulano.tres"))
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão.tres"))
	pass

func adicionar_funcionario_loja(funcionarioData: FuncionarioData):
	if !funcionarioData in listaFuncionarios:
		listaFuncionarios.append(funcionarioData)
		botão_factory(funcionarioData)
	pass

func adicionar_maquina_loja(maquinaData: MaquinaData):
	if !maquinaData in listaMaquinas:
		listaMaquinas.append(maquinaData)
		botão_factory(maquinaData)
	pass

func botão_factory(dados):
	var botão = Button.new()
	botão.pressed.connect(botão_pressionado.bind(botão, dados))
	if dados is FuncionarioData:
		botão.text = dados.nome + " " + str(dados.precoDoFuncionario)
		$Funcionarios.add_child(botão)
	elif dados is MaquinaData:
		botão.text = dados.nome + " " + str(dados.custoInicial)
		$Maquinas.add_child(botão)
	pass

func botão_pressionado(botão: Button, dados: Resource):
	if dados is FuncionarioData:
		if jogadorRef.dinheiro >= dados.precoDoFuncionario:
			BOTÃO_PRESSIONADO.emit(dados)
			botão.queue_free()
	elif dados is MaquinaData:
		if jogadorRef.dinheiro >= dados.custoInicial:
			BOTÃO_PRESSIONADO.emit(dados)
			botão.queue_free()
	pass
