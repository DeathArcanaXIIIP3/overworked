extends Node2D

class_name Maquina

var atributos = []

var tempoDeExecução: int
var taxaDeAcidente: float
var renda: int
var custo: int
var texture: Texture2D
var funcionarioAtual: Funcionario

var isDisponivel: bool

#----------------Funções do Godot------------#
func _ready() -> void:
	atributos = [tempoDeExecução,taxaDeAcidente,renda,custo, isDisponivel]
	pass
#-----------Funções-----------------#
func setup(maquinaData):
	self.tempoDeExecução = maquinaData.tempoDeExecução
	self.taxaDeAcidente = maquinaData.taxaDeAcidente
	self.renda = maquinaData.renda
	self.custo = maquinaData.custoInicial
	self.isDisponivel = maquinaData.isDisponivel

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
	SignalBus.SMaquinas.on_funcionario_começou_a_operar_maquina()
	pass

func tentarMatarFuncionario():
	var taxaFalha = funcionarioAtual.Taxa_de_sobrevivencia * taxaDeAcidente
	var resultado = randf()
	if resultado <= taxaFalha:
		print(resultado)
		print(funcionarioAtual.Nome, " Morreu")
		SignalBus.SMaquinas.on_funcionario_morreu_na_maquina()
	else:
		print(resultado)
		print(funcionarioAtual.Nome, " Terminou de trabalhar")
		SignalBus.SMaquinas.on_funcionario_parou_de_operar_maquina()
	pass

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
