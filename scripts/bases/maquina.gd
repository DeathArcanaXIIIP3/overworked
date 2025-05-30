extends Node2D

class_name Maquina

signal FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA
signal FUNCIONARIO_MORREU_NA_MAQUINA
signal FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA

var atributos = []

var nome: String
var tempoDeExecução: int
var taxaDeAcidente: float
var renda: int
var custo: int
var funcionarioAtual: Funcionario

var isDisponivel: bool

#----------------Funções do Godot------------#
func _ready() -> void:
	atributos = [tempoDeExecução,taxaDeAcidente,renda,custo, isDisponivel, funcionarioAtual]
	pass
#-----------Funções-----------------#
func setup(maquinaData: MaquinaData):
	self.nome = maquinaData.nome
	self.tempoDeExecução = maquinaData.tempoDeExecução
	self.taxaDeAcidente = maquinaData.taxaDeAcidente
	self.renda = maquinaData.renda
	self.custo = maquinaData.custoInicial
	self.isDisponivel = maquinaData.isDisponivel
	$Sprite.texture = maquinaData.texture

func alternarDisponibilidade():
	match isDisponivel:
		true:
			isDisponivel = false
		false:
			isDisponivel = true

func mostrarStatus():
	for n in atributos.size():
		print(atributos[n])

func executarMaquina():
	$Timer.start(tempoDeExecução)
	pass

func adicionarFuncionario(funcionario: Funcionario):
	funcionarioAtual = funcionario
	FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA.emit()
	executarMaquina()
	pass

func tentarMatarFuncionario():
	var taxaFalha = funcionarioAtual.taxaDeSobrevivencia * taxaDeAcidente
	var resultado = randf_range(0.0,1.0)
	var rendaNova = calcular_renda()
	if resultado <= taxaFalha:
		print(resultado)
		print(funcionarioAtual.nome, " Morreu")
		FUNCIONARIO_MORREU_NA_MAQUINA.emit(funcionarioAtual, rendaNova)
	else:
		print(resultado)
		print(funcionarioAtual.nome, " Terminou de trabalhar")
		FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.emit(rendaNova)
	pass

func calcular_renda():
	var rendatotal = funcionarioAtual.produtividade * self.renda
	return rendatotal
#----------------SINAIS---------------#
func _on_timer_timeout() -> void:
	print("A Maquina terminou")
	tentarMatarFuncionario()
	pass # Replace with function body.


func _on_funcionario_começou_a_operar_maquina() -> void:
	print("O funcionario ", funcionarioAtual.Nome, " começou a operar a maquina")
	alternarDisponibilidade()
	executarMaquina()
	pass # Replace with function body.


func _on_funcionario_morreu_na_maquina() -> void:
	alternarDisponibilidade()
	pass # Replace with function body.


func _on_funcionario_parou_de_operar_maquina() -> void:
	alternarDisponibilidade()
	pass # Replace with function body.
