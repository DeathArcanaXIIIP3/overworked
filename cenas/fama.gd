extends TabContainer

class_name Fama

var listaFamaItems: Array[DecoracaoData]

func _ready() -> void:
	# Carrega os 10 items de decoração/fama
	adicionar_fama_item(load("res://resources/decoracoes/planta_escritorio.tres"))
	adicionar_fama_item(load("res://resources/decoracoes/quadro_motivacional.tres"))
	adicionar_fama_item(load("res://resources/decoracoes/mesa_cafe.tres"))
	adicionar_fama_item(load("res://resources/decoracoes/som_ambiente.tres"))
	adicionar_fama_item(load("res://resources/decoracoes/poltrona_ergonomica.tres"))
	adicionar_fama_item(load("res://resources/decoracoes/ar_condicionado.tres"))
	adicionar_fama_item(load("res://resources/decoracoes/academia_corporativa.tres"))
	adicionar_fama_item(load("res://resources/decoracoes/refeitorio_gourmet.tres"))
	adicionar_fama_item(load("res://resources/decoracoes/sala_jogos.tres"))
	adicionar_fama_item(load("res://resources/decoracoes/campanha_marketing.tres"))
	
	EventBus.COMPRA_REALIZADA.connect(remover_item_comprado)
	
	atualizar_loja()

func adicionar_fama_item(famaItemData: DecoracaoData):
	if famaItemData and !famaItemData in listaFamaItems:
		listaFamaItems.append(famaItemData)

func factory_botao(dados: DecoracaoData):
	var botao = Button.new()
	botao.name = dados.nome
	botao.text = "%s\n$%d | +%.0f Fama" % [dados.nome, dados.preco, dados.fama_bonus]
	botao.tooltip_text = "%s\n\n%s\n\nPreço: $%d\nFama Ganha: +%.0f" % [dados.nome, dados.description, dados.preco, dados.fama_bonus]
	botao.pressed.connect(solicitar_compra.bind(dados))
	return botao

func solicitar_compra(itemSolicitado: DecoracaoData):
	EventBus.COMPRA_SOLICITADA.emit(itemSolicitado)
	print("Item de fama solicitado: ", itemSolicitado.nome)

func remover_item_comprado(itemComprado):
	if itemComprado is DecoracaoData and itemComprado in listaFamaItems:
		listaFamaItems.erase(itemComprado)
		atualizar_loja()

func atualizar_loja():
	limpar_loja()
	listar_items()

func limpar_loja():
	var container = get_node_or_null("Loja da fama")
	if not container:
		return
	
	for filho in container.get_children():
		filho.queue_free()

func listar_items():
	# Adiciona botões ao VBoxContainer filho "Loja da fama"
	var container = get_node_or_null("Loja da fama")
	if not container:
		push_error("VBoxContainer 'Loja da fama' não encontrado!")
		return
	
	for item in listaFamaItems:
		var botao = factory_botao(item)
		container.add_child(botao)
