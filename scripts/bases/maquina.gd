extends Node2D

class_name Maquina

signal FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA

var status = []

var data: MaquinaData
var tempoDeExecução: int
var taxaDeAcidente: float
var renda: int
var custo: int
var texture: Texture2D
var funcionarioAtual

var isDisponivel: bool

#----------------Funções do Godot------------#
func _ready() -> void:
	status = [data,tempoDeExecução,taxaDeAcidente,renda,custo, isDisponivel]
	pass
#-----------Funções-----------------#
func setup(maquinaData):
	self.tempoDeExecução = maquinaData.tempoDeExecução
	self.taxaDeAcidente = maquinaData.taxaDeAcidente
	self.renda = maquinaData.renda
	self.custo = maquinaData.custoInicial
	self.isDisponivel = maquinaData.isDisponivel

func mostrarStatus():
	for n in status.size():
		print(status[n])

func executarMaquina():
	$Timer.start(tempoDeExecução)
	pass

func adicionarFuncionario(funcionario):
	self.funcionarioAtual = funcionario
	isDisponivel = false
	FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA.emit()
	pass

func tentarMatarFuncionario(funcionario):
	var taxaSucesso = funcionario.TaxaDeMorte * taxaDeAcidente
	var resultado = randf()
	if resultado <= taxaSucesso:
		print(resultado)
		print(funcionario, " Morreu")
		isDisponivel = true
	else:
		print(resultado)
		print(funcionario.Nome, " Terminou de trabalhar")
		isDisponivel = true
	pass

#----------------SINAIS---------------#
func _on_timer_timeout() -> void:
	print("A Maquina terminou")
	tentarMatarFuncionario(funcionarioAtual)
	mostrarStatus()
	pass # Replace with function body.


func _on_funcionario_começou_a_operar_maquina() -> void:
	print("O funcionario ", funcionarioAtual.Nome, " começou a operar a maquina")
	executarMaquina()
	pass # Replace with function body.
