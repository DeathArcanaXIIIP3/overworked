extends Node2D


class_name Jogador

var almas: int
var dinheiro: int
var fama: float
var inventario_funcionarios: Array = [Funcionario]
var inventario_maquinas: Array = [Maquina]
var inventario_upgrades: Array = []
var inventario_achivements: Array = []

var atributos = []

func _ready() -> void:
	atributos = [almas,dinheiro,fama,inventario_funcionarios,inventario_maquinas,inventario_upgrades,inventario_achivements]
	
	pass


func get_almas() -> int:
	return almas

func set_almas(almas_value: int) -> void:
	almas = almas_value
	pass

func get_dinheiro() -> int:
	return dinheiro

func set_dinheiro(dinheiro_value: int) -> void:
	dinheiro = dinheiro_value
	pass

func get_fama() -> float:
	return fama

func set_fama(fama_value: float) -> void:
	fama = fama_value
	pass

func add_dinheiro(adicionar: int) -> void:
	dinheiro = dinheiro + adicionar
	pass

func sub_dinheiro(subtrair: int) -> void:
	dinheiro = dinheiro - subtrair
	pass

func add_almas(adicionar: int) -> void:
	almas = almas + adicionar
	pass

func sub_almas(subtrair: int) -> void:
	almas = almas - subtrair
	pass

func add_fama(adicionar: float) -> void:
	fama = fama + adicionar
	pass

func sub_fama(subtrair: float) -> void:
	fama = fama - subtrair
	pass

func adicionar_funcionarios(funcionario_selecionado: Funcionario) -> void:
	inventario_funcionarios.append(funcionario_selecionado)
	pass

func retirar_funcionarios(funcionario_selecionado: Funcionario) -> void:
	inventario_funcionarios.erase(funcionario_selecionado)
	pass

func adicionar_maquinas(maquina_selecionada: Maquina) -> void:
	inventario_maquinas.append(maquina_selecionada)
	pass

func retirar_maquinas(maquina_selecionada: Maquina) -> void:
	inventario_maquinas.erase(maquina_selecionada)
	pass
