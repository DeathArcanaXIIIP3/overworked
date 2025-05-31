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
var inventarioMaquinas: Array[MaquinaData]
var inventarioFuncionarios: Array[FuncionarioData]
var inventarioUpgrades = []

var screenSize

func _ready():
	JOGADOR_PRONTO.emit(self)
	screenSize = get_viewport().get_visible_rect().size
	pass

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

func adicionar_funcionario_inventario(funcionario: FuncionarioData):
	inventarioFuncionarios.append(funcionario)
	FUNCIONARIO_ADICIONADO_AO_INVENTARIO.emit(funcionario)
	return inventarioFuncionarios

func adicionar_maquina_invenatario(maquina: MaquinaData):
	inventarioMaquinas.append(maquina)
	MAQUINA_ADICIONADO_AO_INVENTARIO.emit(maquina)
	return inventarioMaquinas

func adicionar_upgrade_inventario(upgrade):
	inventarioUpgrades.append(upgrade)
	UPGRADE_ADICIONADO_AO_INVENTARIO.emit()
	return inventarioUpgrades

func factory_funcionario(data: FuncionarioData):
	var funcionario = preload("res://cenas/funcionario.tscn").instantiate()
	funcionario.MEDO_MAXIMO_ATINGIDO.connect(func (funcionario_atual):
		atualizar_dados(funcionario_atual) #feito por lorenzo(ja sabe ne)
		alterar_fama(-0.1))
	add_child(funcionario)
	funcionario.setup(data)
	funcionario.global_position = Vector2(screenSize[0]/2, screenSize[1]/2)
	return funcionario

func factory_maquina(data: MaquinaData):
	var maquina = preload("res://cenas/maquina.tscn").instantiate()
	maquina.FUNCIONARIO_MORREU_NA_MAQUINA.connect(func (funcionario, renda): 
		_deletar_funcionario(funcionario) 
		alterar_dinheiro(renda))
	maquina.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.connect(func (renda, funcionario):
		alterar_dinheiro(renda)
		funcionario.atualizarMedo())
	add_child(maquina)
	maquina.setup(data)
	maquina.global_position = Vector2(screenSize[0] / 2, screenSize[1] / 2)
	return maquina

func _on_loja_botão_pressionado(dados) -> void:
	if dados is FuncionarioData:
		alterar_dinheiro(-dados.Preço_do_funcionario)
		adicionar_funcionario_inventario(dados)
	elif dados is MaquinaData:
		adicionar_maquina_invenatario(dados)
	pass # Replace with function body.

func _deletar_funcionario(funcionario: Funcionario):
	var sprite : Sprite2D 
	var animation : AnimatedSprite2D
	animation = funcionario.get_child(1)
	sprite = funcionario.get_child(0)
	sprite.visible = false
	animation.visible = true
	animation.play("morte")
	animation.animation_finished.connect(func():deletar_funcionario(funcionario))
	pass

func deletar_funcionario(funcionario: Funcionario):
	alterar_almas(+1)
	funcionario.queue_free()
	pass

func atualizar_dados(funcionario: Funcionario):
	funcionario.queue_free()
