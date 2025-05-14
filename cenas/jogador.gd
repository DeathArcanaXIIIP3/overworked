extends Node2D


class_name Jogador

var Almas: int
var Dinheiro: int
var Fama: float
var Inventario_Funcionarios: Array = []
var Inventario_Maquinas: Array = []
var Inventario_Upgrades: Array = []
var Inventario_Achivements: Array = []

func add_dinheiro(modificar: int) -> void:
	Dinheiro = Dinheiro + modificar
	pass

func alterar_almas(modificar: int) -> void:
	Almas = Almas + modificar
	pass

func alterar_fama(modificar: float) -> void:
	Fama = Fama + modificar
	pass

func adicionar_inventario_funcionarios(funcionario_selecionado: Funcionario) -> void:
	Inventario_Funcionarios.append(funcionario_selecionado)
	pass

func retirar_inventario_funcionarios(funcionario_selecionado: Funcionario) -> void:
	Inventario_Funcionarios.erase(funcionario_selecionado)
	pass

func adicionar_inventario_maquinas(maquina_selecionada: Maquina) -> void:
	Inventario_Maquinas.append(maquina_selecionada)
	pass

func retirar_inventario_maquinas(maquina_selecionada: Maquina) -> void:
	Inventario_Maquinas.erase(maquina_selecionada)
	pass
