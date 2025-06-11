extends Node2D

class_name Maquina

signal FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA
signal FUNCIONARIO_MORREU_NA_MAQUINA
signal FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA

var nome: String
var renda: int
var preco: int
#---Multiplicadores---#
var tempoDeExecução: int
var taxaDeAcidente: float
#---Resource---#
var resource: MaquinaData
#---Referencias de Nodes---#
var funcionarioAtual: Funcionario
#---Booleanos para checagem de status---#
var isDisponivel: bool

#----------------Funções do Godot------------#
func _ready() -> void:
	pass
#-----------Funções-----------------#
func inicializar(dados: MaquinaData):
	self.nome = dados.nome
	self.renda = dados.renda
	self.preco = dados.preco
	self.resource = dados
	self.tempoDeExecução = dados.tempoDeExecução
	self.taxaDeAcidente = dados.taxaDeAcidente
	self.isDisponivel = dados.isDisponivel
	$Sprite.texture = dados.texture

func alternarDisponibilidade():
	isDisponivel = !isDisponivel
	print(isDisponivel)

func executarMaquina():
	$Timer.start(tempoDeExecução)
	pass

func adicionarFuncionario(funcionario: Funcionario):
	if isDisponivel == null:
		push_warning("isDisponivel NULL!")
	elif isDisponivel:
		funcionarioAtual = funcionario
		funcionarioAtual.alternarDisponibilidade()
		FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA.emit()
	else:
		print("SINAL: Maquina em uso")
	pass

func tentarMatarFuncionario():
	var taxaDeSucesso = funcionarioAtual.taxaDeAcidente * taxaDeAcidente
	var resultado = randf_range(0.0,1.0)
	var rendaNova = calcular_renda()
	if resultado <= taxaDeSucesso:
		print(resultado)
		print(funcionarioAtual.nome, " Morreu")
		FUNCIONARIO_MORREU_NA_MAQUINA.emit(funcionarioAtual, rendaNova)
		alternarDisponibilidade()
	else:
		print(resultado)
		print(funcionarioAtual.nome, " Terminou de trabalhar")
		FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.emit(rendaNova,funcionarioAtual)
		alternarDisponibilidade()
	pass

func calcular_renda():
	var rendatotal = funcionarioAtual.produtividade * self.renda
	funcionarioAtual.produtividade = funcionarioAtual.produtividade - funcionarioAtual.produtividade * 0.1
	return rendatotal
#----------------SINAIS---------------#
func _on_timer_timeout() -> void:
	print("A Maquina terminou")
	funcionarioAtual.alternarDisponibilidade()
	tentarMatarFuncionario()
	pass # Replace with function body.
