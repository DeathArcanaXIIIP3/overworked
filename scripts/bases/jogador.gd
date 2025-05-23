extends Node

class_name Jogador

var nome: String
var almas: int
var dinheiro: int
var fama: float
var inventarioMaquinas: Array[Maquina]
var inventarioFuncionarios: Array[Funcionario]
var inventarioUpgrades = []

func definir_Nome(novoNome: String):
	nome = novoNome

func alterar_dinheiro(novoValor: int):
	dinheiro += novoValor

func alterar_fama(novoValor: float):
	fama += novoValor

func alterar_almas(novoValor: int):
	almas += novoValor

func remove_funcionario_inventario(funcionario: Funcionario):
	inventarioFuncionarios.erase(funcionario)

func remove_maquina_invenatario(maquina: Maquina):
	inventarioMaquinas.erase(maquina)

func remove_upgrade_inventario(upgrade):
	inventarioUpgrades.erase(upgrade)

func adicionar_funcionario_inventario(funcionario: Funcionario):
	inventarioFuncionarios.append(funcionario)

func adicionar_maquina_invenatario(maquina: Maquina):
	inventarioMaquinas.append(maquina)

func adicionar_upgrade_inventario(upgrade):
	inventarioUpgrades.append(upgrade)
