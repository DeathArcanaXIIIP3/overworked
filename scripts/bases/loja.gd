extends TabContainer

class_name Loja

signal ATUALIZAR_INVENTARIO

var listaFuncionarios : Array[FuncionarioData]
var listaMaquinas : Array[MaquinaData]
var listaUpgrades: Array[UpgradeData]
var listaDecoracoes: Array[DecoracaoData]

func _ready() -> void:
	EventBus.NOVO_FUNCIONARIO_GERADO.connect(adicionar_funcionario_loja)
	
	# Adiciona 10 funcionários iniciais
	adicionar_funcionario_loja(load("res://resources/funcionarios/Fulana.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Fulano.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Gabriel.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Jonas.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Fernanda.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Kleber.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Leonardo.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Lorenzo.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Louise.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Thomas.tres"))
	
	# Adiciona 12 máquinas iniciais (duplicando as existentes)
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão2.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_ImpressãoC.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão2.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_ImpressãoC.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão2.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_ImpressãoC.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão2.tres").duplicate())
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_ImpressãoC.tres").duplicate())
	
	# Upgrades
	adicionar_upgrade_loja(load("res://resources/upgrades/funcionario_2x_produtividade.tres"))
	adicionar_upgrade_loja(load("res://resources/upgrades/maquina_2x_renda.tres"))
	adicionar_upgrade_loja(load("res://resources/upgrades/funcionario_diminui_medo.tres"))
	adicionar_upgrade_loja(load("res://resources/upgrades/maquina_diminui_tempo.tres"))
	adicionar_upgrade_loja(load("res://resources/upgrades/funcionario_mais_almas.tres"))
	
	# Decorações (Loja de Fama)
	adicionar_decoracao_loja(load("res://resources/decoracoes/planta_escritorio.tres"))
	adicionar_decoracao_loja(load("res://resources/decoracoes/quadro_motivacional.tres"))
	adicionar_decoracao_loja(load("res://resources/decoracoes/mesa_cafe.tres"))
	adicionar_decoracao_loja(load("res://resources/decoracoes/som_ambiente.tres"))
	adicionar_decoracao_loja(load("res://resources/decoracoes/poltrona_ergonomica.tres"))
	adicionar_decoracao_loja(load("res://resources/decoracoes/ar_condicionado.tres"))
	adicionar_decoracao_loja(load("res://resources/decoracoes/academia_corporativa.tres"))
	adicionar_decoracao_loja(load("res://resources/decoracoes/refeitorio_gourmet.tres"))
	adicionar_decoracao_loja(load("res://resources/decoracoes/sala_jogos.tres"))
	adicionar_decoracao_loja(load("res://resources/decoracoes/campanha_marketing.tres"))
	pass

func adicionar_upgrade_loja(upgradeData: UpgradeData):
	if !upgradeData in listaUpgrades:
		listaUpgrades.append(upgradeData)
	ATUALIZAR_INVENTARIO.emit()

func adicionar_funcionario_loja(funcionarioData: FuncionarioData):
	if !funcionarioData in listaFuncionarios:
		listaFuncionarios.append(funcionarioData)
	ATUALIZAR_INVENTARIO.emit()

func adicionar_maquina_loja(maquinaData: MaquinaData):
	if !maquinaData in listaMaquinas:
		listaMaquinas.append(maquinaData)
	ATUALIZAR_INVENTARIO.emit()

func adicionar_decoracao_loja(decoracaoData: DecoracaoData):
	if !decoracaoData in listaDecoracoes:
		listaDecoracoes.append(decoracaoData)
	ATUALIZAR_INVENTARIO.emit()

func factory_botao(dados: Resource):
	var botao = Button.new()
	botao.name = dados.nome
	
	# Formata o texto do botão com informações relevantes
	if dados is FuncionarioData:
		botao.text = "%s\n$%d | Prod: %.1f" % [dados.nome, dados.preco, dados.produtividade]
		botao.tooltip_text = "Nome: %s\nPreço: $%d\nProdutividade: %.1f\nTaxa de Medo: %.1f%%\nTaxa de Acidente: %.1f%%" % [
			dados.nome, 
			dados.preco, 
			dados.produtividade, 
			dados.taxa_de_medo * 100,
			dados.taxa_de_acidente * 100
		]
	elif dados is MaquinaData:
		botao.text = "%s\n$%d | +$%d" % [dados.nome, dados.preco, dados.renda]
		botao.tooltip_text = "Nome: %s\nPreço: $%d\nRenda: $%d\nTempo de Trabalho: %ds" % [
			dados.nome,
			dados.preco,
			dados.renda,
			dados.tempoDeExecução
		]
	elif dados is UpgradeData:
		botao.text = "%s\n%d Almas" % [dados.nome, dados.preco]
		botao.tooltip_text = "%s\n\n%s\n\nPreço: %d Almas" % [dados.nome, dados.description, dados.preco]
	elif dados is DecoracaoData:
		botao.text = "%s\n$%d | +%.0f Fama" % [dados.nome, dados.preco, dados.fama_bonus]
		botao.tooltip_text = "Nome: %s\nPreço: $%d\nBônus de Fama: +%.1f\n\n%s" % [
			dados.nome,
			dados.preco,
			dados.fama_bonus,
			dados.description
		]
	else:
		botao.text = dados.nome
	
	botao.pressed.connect(solicitar_compra.bind(dados))
	return botao

func apagar_botao(botao: Button):
	botao.queue_free()
	pass

func solicitar_compra(itemSolicitado):
	EventBus.COMPRA_SOLICITADA.emit(itemSolicitado)
	print(itemSolicitado)

func remover_item_da_loja(itemComprado):
	if itemComprado == null:
		push_warning("Item comprado NULL")
	elif itemComprado is FuncionarioData:
		listaFuncionarios.erase(itemComprado)
	elif itemComprado is MaquinaData:
		listaMaquinas.erase(itemComprado)
	elif itemComprado is UpgradeData:
		listaUpgrades.erase(itemComprado)
	elif itemComprado is DecoracaoData:
		listaDecoracoes.erase(itemComprado)
	atualizar_inventarios()

func atualizar_inventarios():
	limpar_inventarios()
	listar_inventarios()

func limpar_inventarios():
	for filho in $Funcionarios.get_children():
		filho.queue_free()
	for filho in $Maquinas.get_children():
		filho.queue_free()
	for filho in $Upgrades.get_children():
		filho.queue_free()
	if has_node("Decorações"):
		for filho in $"Decorações".get_children():
			filho.queue_free()

func listar_inventarios():
	var botao : Button
	for itens in listaFuncionarios:
		botao = factory_botao(itens)
		$Funcionarios.add_child(botao)
	for itens in listaMaquinas:
		botao = factory_botao(itens)
		$Maquinas.add_child(botao)
	for itens in listaUpgrades:
		botao = factory_botao(itens)
		$Upgrades.add_child(botao)
	if has_node("Decorações"):
		for itens in listaDecoracoes:
			botao = factory_botao(itens)
			$"Decorações".add_child(botao)

func _on_atualizar_inventario() -> void:
	atualizar_inventarios()
	pass # Replace with function body.
