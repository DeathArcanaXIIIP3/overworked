extends Node

class_name Jogador

signal JOGADOR_PRONTO
signal FUNCIONARIO_REMOVIDO_DO_INVENTARIO
signal FUNCIONARIO_ADICIONADO_AO_INVENTARIO
signal MAQUINA_REMOVIDA_DO_INVENTARIO
signal MAQUINA_ADICIONADO_AO_INVENTARIO
signal UPGRADE_REMOVIDO_DO_INVENTARIO
signal UPGRADE_ADICIONADO_AO_INVENTARIO
signal ALMAS_ALTERADA
signal FAMA_ALTERADA
signal DINHEIRO_ALTERADO
signal NOME_ALTERADO


var nome: String
var almas: int
var dinheiro: int
var fama: float
var inventarioMaquinas: Array[Maquina]
var inventarioFuncionarios: Array[Funcionario]
var inventarioUpgrades = []

func _ready():
	pass

func _teste():
	JOGADOR_PRONTO.emit(self)

func definir_Nome(novoNome: String):
	nome = novoNome
	NOME_ALTERADO.emit()
	return nome

func alterar_dinheiro(novoValor: int):
	dinheiro += novoValor
	DINHEIRO_ALTERADO.emit()
	return dinheiro

func alterar_fama(novoValor: float):
	fama += novoValor
	FAMA_ALTERADA.emit()
	return fama

func alterar_almas(novoValor: int):
	almas += novoValor
	ALMAS_ALTERADA.emit()
	return almas

func remove_funcionario_inventario(funcionario: Funcionario):
	inventarioFuncionarios.erase(funcionario)
	FUNCIONARIO_REMOVIDO_DO_INVENTARIO.emit()
	return inventarioFuncionarios

func remove_maquina_invenatario(maquina: Maquina):
	inventarioMaquinas.erase(maquina)
	MAQUINA_REMOVIDA_DO_INVENTARIO.emit()
	return inventarioMaquinas

func remove_upgrade_inventario(upgrade):
	inventarioUpgrades.erase(upgrade)
	UPGRADE_REMOVIDO_DO_INVENTARIO.emit()
	return inventarioUpgrades

func adicionar_funcionario_inventario(funcionario: Funcionario):
	inventarioFuncionarios.append(funcionario)
	FUNCIONARIO_ADICIONADO_AO_INVENTARIO.emit()
	return inventarioFuncionarios

func adicionar_maquina_invenatario(maquina: Maquina):
	inventarioMaquinas.append(maquina)
	MAQUINA_ADICIONADO_AO_INVENTARIO.emit()
	return inventarioMaquinas

func adicionar_upgrade_inventario(upgrade):
	inventarioUpgrades.append(upgrade)
	UPGRADE_ADICIONADO_AO_INVENTARIO.emit()
	return inventarioUpgrades
