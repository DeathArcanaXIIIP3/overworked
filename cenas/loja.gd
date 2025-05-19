extends Node2D

class_name Loja

var atributos = []

var estoque_funcionarios: Array = [Funcionario]
var estoque_maquinas: Array = [Maquina]
var jogador = Jogador.new()
func _ready() -> void:
	
	atributos = [estoque_funcionarios,estoque_maquinas]
	
	pass

func gerar_funcionarios(funcionario_selecionado: Funcionario) -> void:
	estoque_funcionarios.append(funcionario_selecionado)
	pass

func vender_funcionario(funcionario_selecionado: Funcionario, custo_funcionario: int) -> void:
	jogador.adicionar_funcionarios(funcionario_selecionado)
	jogador.sub_dinheiro(custo_funcionario)
	estoque_funcionarios.erase(funcionario_selecionado)
	pass

func vender_maquinas(maquina_selecionada: Maquina, custo_maquina: int) -> void:
	jogador.adicionar_maquinas(maquina_selecionada)
	jogador.sub_dinheiro(custo_maquina)
	estoque_maquinas.erase(maquina_selecionada)
	pass
