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
#---Progresso do Timer em segundos---#
var timerProgresso = 0
#---Booleanos para checagem de status---#
var isDisponivel: bool

#----------------Funções do Godot------------#
func _ready() -> void:
	FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA.connect(Callable(self,"executarMaquina"))
	pass

func _process(_delta: float) -> void:
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
	$Control/ProgressBar.value = 0
	$Control/ProgressBar.min_value = 0
	$Control/ProgressBar.max_value = tempoDeExecução

func alternarDisponibilidade():
	isDisponivel = !isDisponivel
	print(isDisponivel)

func executarMaquina():
	$Timer.start(1)
	pass

func adicionarFuncionario(funcionario: Funcionario):
	if isDisponivel == null:
		push_warning("isDisponivel NULL!")
		return
	
	if not isDisponivel:
		print(nome, " já está em uso por ", funcionarioAtual.nome if funcionarioAtual else "alguém")
		return
	
	if not is_instance_valid(funcionario):
		push_warning("Funcionário inválido!")
		return
	
	funcionarioAtual = funcionario
	funcionarioAtual.global_position = $Ancora.global_position
	funcionarioAtual.alternarDisponibilidade()
	self.alternarDisponibilidade()
	FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA.emit()
	pass

func tentarMatarFuncionario():
	var taxaDeSucesso = funcionarioAtual.taxaDeAcidente * taxaDeAcidente
	var resultado = randf_range(0.0,1.0)
	var rendaNova = calcular_renda()
	if resultado <= taxaDeSucesso:
		print(resultado)
		print(funcionarioAtual.nome, " Morreu")
		FUNCIONARIO_MORREU_NA_MAQUINA.emit(funcionarioAtual, rendaNova)
		EventBus.FUNCIONARIO_MORREU_NA_MAQUINA.emit(funcionarioAtual,rendaNova)
		alternarDisponibilidade()
	else:
		print(resultado)
		print(funcionarioAtual.nome, " Terminou de trabalhar")
		FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.emit(rendaNova,funcionarioAtual)
		EventBus.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.emit(rendaNova,funcionarioAtual)
		self.alternarDisponibilidade()
	pass

func calcular_renda():
	var rendatotal = funcionarioAtual.produtividade * self.renda
	funcionarioAtual.produtividade = max(0.1, funcionarioAtual.produtividade - funcionarioAtual.produtividade * 0.1)
	return roundi(rendatotal)

func reset_timer():
	$Timer.stop()
	timerProgresso = 0
	
func reset_progress_bar():
	$Control/ProgressBar.value = 0
	$Control/ProgressBar.max_value = tempoDeExecução

#----------------SINAIS---------------#
func _on_timer_timeout() -> void:
	if timerProgresso >= tempoDeExecução:
		reset_timer()
		reset_progress_bar()
		print("A Maquina terminou")
		if is_instance_valid(funcionarioAtual):
			funcionarioAtual.alternarDisponibilidade()
			tentarMatarFuncionario()
	else:
		timerProgresso += 1
		$Control/ProgressBar.value = timerProgresso
	pass # Replace with function body.
