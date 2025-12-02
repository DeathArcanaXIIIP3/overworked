extends Node

class_name Jogador

@onready var jogadorGUIRef: JogadorGUI = $"../Jogador_GUI"

var nome: String = "Maritaca"
var almas: int = 100
var dinheiro: int = 2000
var fama: float = 70.0  # Sistema de Fama: 0-100 (0 = Game Over)
var cota: int = 0
var inventarioMaquinas: Array[MaquinaData]
var inventarioFuncionarios: Array[FuncionarioData]
var inventarioUpgrades: Array[UpgradeData]
var inventarioDecoracoes: Array[DecoracaoData]

var decoracoes_colocadas: int = 0  # Contador de decorações no jogo
var placed_decoracoes: Array = [] # Nós das decorações colocadas (para fama diária)

var screenSize
var espacamento = Vector2(100, 80) 
var maquina_size = Vector2(100, 100) 
var margem_x = 200  # Margem das bordas
var margem_y = 400 # Margem superior (para HUD)
var area_disponivel_y = 50  # Área disponível vertical
var maquinas_por_linha = 5  # Reduzido para melhor distribuição
var total_maquinas_criadas = 0
var maquinas_totais = 0

func _ready():
	EventBus.NOVA_COTA.emit()
	EventBus.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.connect(alterar_cota)
	EventBus.FIM_DO_MES.connect(checar_cota_alcancada)
	# Conecta para receber o fim do dia (gerar fama proveniente das decorações)
	if EventBus.has_signal("FIM_DO_DIA"):
		EventBus.FIM_DO_DIA.connect(_on_fim_do_dia)
	EventBus.FUNCIONARIO_MORREU_NA_MAQUINA.connect(_on_funcionario_morreu)
	EventBus.FUNCIONARIO_FUGIU.connect(_on_funcionario_fugiu)
	#EventBus.FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA.connect(Callable(self,"soma_maquinas_total"))
	#EventBus.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.connect(reduz_maquinas_total)
	screenSize = get_viewport().size
	area_disponivel_y = screenSize.y - margem_y - 50  # 50 = margem inferior
	calcular_grid_otimo()
	pass

func calcular_grid_otimo():
	# Calcula quantas máquinas cabem por linha considerando as margens
	var largura_disponivel = screenSize.x - (margem_x * 2)
	maquinas_por_linha = max(1, int(largura_disponivel / (maquina_size.x + espacamento.x)))

func adicionar_upgrade(itemRecebido: Resource):
	if itemRecebido == null:
		push_warning("Item recebido tipo NULL")
	elif itemRecebido is UpgradeData:
		if itemRecebido.ativo == false:
			itemRecebido.ativo = true
			inventarioUpgrades.append(itemRecebido)
			ativar_upgrade(itemRecebido)
		else:
			print("Upgrade já esta no inventario")

func ativar_upgrade(upgrade: UpgradeData):
	var lojaRef: Loja = jogadorGUIRef.get_node("Loja")
	var filhosJogador: Array = self.get_children()
	if upgrade == null:
		push_warning("Upgrade recebido tipo NULL")
	elif upgrade is maquinaUpgrade or upgrade is maquinaDiminuiTempoUpgrade:
		for n in inventarioMaquinas.size():
			print("Antes: ",inventarioMaquinas[n].nome)
			upgrade.aplicar_upgrade(inventarioMaquinas[n])
			print("Depois: aplicado")
		for n in lojaRef.listaMaquinas.size():
			upgrade.aplicar_upgrade(lojaRef.listaMaquinas[n])
		for n in filhosJogador.size():
			if filhosJogador[n] is Maquina and is_instance_valid(filhosJogador[n]):
				upgrade.aplicar_upgrade(filhosJogador[n])
				# Efeito visual na máquina (vermelho)
				var VisualEffects = preload("res://scripts/visual_effects.gd")
				VisualEffects.flash_node(filhosJogador[n], Color.RED, 0.5)
				VisualEffects.pulse_node(filhosJogador[n], 1.2, 0.4)
				if is_instance_valid(filhosJogador[n].get_parent()):
					VisualEffects.create_upgrade_particles(filhosJogador[n].get_parent(), filhosJogador[n].global_position, Color.RED)
	elif upgrade is funcionarioUpgrade or upgrade is funcionarioDiminuiMedoUpgrade or upgrade is funcionarioMaisAlmasUpgrade:
		for n in inventarioFuncionarios.size():
			print("Antes: ",inventarioFuncionarios[n].nome)
			upgrade.aplicar_upgrade(inventarioFuncionarios[n])
			print("Depois: aplicado")
		for n in lojaRef.listaFuncionarios.size():
			upgrade.aplicar_upgrade(lojaRef.listaFuncionarios[n])
		for n in filhosJogador.size():
			if filhosJogador[n] is Funcionario and is_instance_valid(filhosJogador[n]):
				upgrade.aplicar_upgrade(filhosJogador[n])
				# Efeito visual no funcionário (dourado)
				var VisualEffects = preload("res://scripts/visual_effects.gd")
				VisualEffects.flash_node(filhosJogador[n], Color.GOLD, 0.5)
				VisualEffects.pulse_node(filhosJogador[n], 1.2, 0.4)
				if is_instance_valid(filhosJogador[n].get_parent()):
					VisualEffects.create_upgrade_particles(filhosJogador[n].get_parent(), filhosJogador[n].global_position, Color.GOLD)
	pass

func definir_Nome(novoNome: String):
	nome = novoNome
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.emit()
	return nome

func alterar_cota(novoValor: int, _funcionario):
	if cota > 0:
		cota -= novoValor
		if cota <= 0:
			cota = 0
			EventBus.ATUALIZAR_COTA_GUI.emit(cota)
			EventBus.COTA_ALCANCADA.emit()
		EventBus.ATUALIZAR_COTA_GUI.emit(cota)
	pass

func alterar_dinheiro(novoValor: int):
	dinheiro += novoValor
	dinheiro = max(0, dinheiro)
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.emit()
	return dinheiro

func alterar_fama(novoValor: float):
	var fama_antiga = fama
	fama += novoValor
	fama = clamp(fama, 0.0, 100.0)
	
	# Verifica se fama mudou significativamente
	if abs(fama - fama_antiga) > 0.1:
		EventBus.ATUALIZAR_ATRIBUTOS_GUI.emit()
	
	# Game Over se fama chegar a 0
	if fama <= 0:
		game_over_fama()
	# Alerta quando fama está baixa
	elif fama <= 20 and fama_antiga > 20:
		EventBus.FAMA_CRITICA.emit()
	
	return fama

func game_over_fama():
	print("GAME OVER: Sua empresa foi descoberta!")
	get_tree().paused = true
	EventBus.GAME_OVER.emit("descoberto")

func alterar_almas(novoValor: int):
	almas += novoValor
	almas = max(0, almas)
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.emit()
	return almas

func consultar_saldo_para_compra(itemSolicitado: Resource):
	if itemSolicitado is UpgradeData:
		if itemSolicitado.preco <= almas:
			adicionar_ao_inventario(itemSolicitado)
			alterar_almas(-itemSolicitado.preco)
			EventBus.COMPRA_REALIZADA.emit(itemSolicitado)
		else:
			print("SALDO INSUFICIENTE - Precisa de ", itemSolicitado.preco, " almas")
	elif itemSolicitado is DecoracaoData:
		if itemSolicitado.preco <= dinheiro:
			# Compra decoração e adiciona ao inventário (fama aumenta quando colocar no jogo)
			alterar_dinheiro(-itemSolicitado.preco)
			adicionar_ao_inventario(itemSolicitado)
			EventBus.COMPRA_REALIZADA.emit(itemSolicitado)
			print("Comprou ", itemSolicitado.nome, " - coloque no jogo para ganhar fama!")
		else:
			print("SALDO INSUFICIENTE - Precisa de $", itemSolicitado.preco)
	elif itemSolicitado is MaquinaData or itemSolicitado is FuncionarioData:
		if itemSolicitado.preco <= dinheiro:
			adicionar_ao_inventario(itemSolicitado)
			alterar_dinheiro(-itemSolicitado.preco)
			EventBus.COMPRA_REALIZADA.emit(itemSolicitado)
		else:
			print("SALDO INSUFICIENTE - Precisa de $", itemSolicitado.preco)

func adicionar_ao_inventario(itemRecebido: Resource):
	if itemRecebido == null:
		push_warning("Item recebido tipo NULL!")
	elif itemRecebido is FuncionarioData:
		inventarioFuncionarios.append(itemRecebido)
	elif itemRecebido is MaquinaData:
		inventarioMaquinas.append(itemRecebido)
		factory_maquina(itemRecebido)
	elif itemRecebido is UpgradeData:
		if itemRecebido.ativo == false:
			itemRecebido.ativo = true
			inventarioUpgrades.append(itemRecebido)
			ativar_upgrade(itemRecebido)
	elif itemRecebido is DecoracaoData:
		inventarioDecoracoes.append(itemRecebido)
	EventBus.ATUALIZAR_INVENTARIOS_GUI.emit()

func remover_do_inventario(itemSelecionado: Resource):
	if itemSelecionado == null:
		push_warning("Item selecionado tipo NULL!")
	elif itemSelecionado is FuncionarioData:
		inventarioFuncionarios.erase(itemSelecionado)
	elif itemSelecionado is MaquinaData:
		inventarioMaquinas.erase(itemSelecionado)
	elif itemSelecionado is DecoracaoData:
		inventarioDecoracoes.erase(itemSelecionado)
	EventBus.ATUALIZAR_INVENTARIOS_GUI.emit()

func instanciar_objetos(dados: Resource):
	if dados == null:
		push_warning("Resource NULL")
	elif dados is FuncionarioData:
		remover_do_inventario(dados)
		return factory_funcionario(dados)
	elif dados is MaquinaData:
		remover_do_inventario(dados)
		return factory_maquina(dados)
	elif dados is DecoracaoData:
		remover_do_inventario(dados)
		return factory_decoracao(dados)

func factory_funcionario(dados: FuncionarioData):
	var funcionario = preload("res://cenas/funcionario.tscn").instantiate()
	funcionario.name = dados.nome
	EventBus.FUNCIONARIO_ENTROU_NA_CENA.emit(funcionario)
	
	EventBus.MEDO_MAXIMO_ATINGIDO.connect(func(funcionario_atual):
		atualizar_dados(funcionario_atual)
		alterar_fama(-0.1))
	EventBus.PEDIR_RETORNO_PARA_INVENTARIO.connect(func(f):
		retornar_funcionario_para_inventario(f))

	add_child(funcionario)
	funcionario.setup(dados)
	funcionario.global_position = Vector2(screenSize[0]/2, screenSize[1]/2)
	return funcionario
	
func factory_decoracao(dados: DecoracaoData):
	# Instancia a cena de decoração, que já possui Area2D para arrastar
	var decoracao_scene = load("res://cenas/decoracao.tscn").instantiate()
	decoracao_scene.name = dados.nome

	# Ajusta sprite interno se existir
	if decoracao_scene.has_node("Sprite2D"):
		var sprite = decoracao_scene.get_node("Sprite2D")
		if dados.texture != null:
			sprite.texture = dados.texture
		else:
			sprite.texture = load("res://icon.svg")
		sprite.scale = Vector2(0.5, 0.5)
		decoracao_scene.set_meta("sprite_ref", sprite)

	# Ajusta label
	if decoracao_scene.has_node("Label"):
		var label = decoracao_scene.get_node("Label")
		label.text = dados.nome

	# Posiciona na parte inferior da tela com espaçamento
	var espacamento_decoracao = 100  # Espaçamento entre decorações
	var pos_x = 600 + (decoracoes_colocadas * espacamento_decoracao)  # Começa mais à direita
	var pos_y = screenSize.y - 200  # Mais acima (200 pixels da borda inferior)
	decoracao_scene.global_position = Vector2(pos_x, pos_y)

	# Guarda metadados úteis para processamento diário
	decoracao_scene.set_meta("fama_bonus", dados.fama_bonus)
	decoracao_scene.set_meta("dados_decoracao", dados)

	# Adiciona à lista de decorações colocadas (receberão fama diariamente)
	placed_decoracoes.append(decoracao_scene)

	decoracoes_colocadas += 1
	add_child(decoracao_scene)
	print("Decoração ", dados.nome, " adicionada ao jogo! (registrada para fama diária)")
	return decoracao_scene

func _on_fim_do_dia() -> void:
	# Soma a fama de todas as decorações colocadas e aplica ao jogador no fim do dia
	var total_fama: float = 0.0
	for d in placed_decoracoes:
		if is_instance_valid(d) and d.has_meta("fama_bonus"):
			total_fama += float(d.get_meta("fama_bonus"))
	if total_fama > 0.0:
		alterar_fama(total_fama)
		print("Fama diária gerada por decorações: ", total_fama)

func retornar_funcionario_para_inventario(funcionario: Funcionario):
	for dados in inventarioFuncionarios:
		if dados.nome == funcionario.nome:
			 # Já existe no inventário, apenas reativar
			dados.isDisponivel = true
			funcionario.queue_free()
			EventBus.ATUALIZAR_INVENTARIOS_GUI.emit()
			return

	var dados = FuncionarioData.new()
	dados.nome = funcionario.nome
	dados.produtividade = funcionario.produtividade
	dados.preco = funcionario.preco
	dados.taxa_de_acidente = funcionario.taxaDeAcidente
	dados.taxa_de_medo = funcionario.taxaDeMedo
	dados.isDisponivel = true
	dados.profilePicture = funcionario.profilePicture
	adicionar_ao_inventario(dados)
	funcionario.queue_free()


func factory_maquina(dados: MaquinaData):
	var maquina = preload("res://cenas/maquina.tscn").instantiate()
	maquina.name = dados.nome
	
	maquina.FUNCIONARIO_MORREU_NA_MAQUINA.connect(func (funcionario, renda): 
		reduz_maquinas_total(maquina)
		_deletar_funcionario(funcionario)
		alterar_dinheiro(renda))
	
	maquina.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.connect(func (renda, funcionario):
		print("FUNCIONARIO PAROU DE OPERAR")
		reduz_maquinas_total(maquina)
		alterar_dinheiro(renda)
		if is_instance_valid(funcionario):
			funcionario.atualizarMedo())
	
	if maquinas_totais < 0:
		maquinas_totais = 0
	
	# Recalcula o grid se necessário para acomodar todas as máquinas
	var num_maquinas = total_maquinas_criadas + 1
	var linhas_necessarias = ceil(float(num_maquinas) / float(maquinas_por_linha))
	
	# Se as linhas não cabem na tela, reduz o espaçamento ou número por linha
	var altura_necessaria = linhas_necessarias * (maquina_size.y + espacamento.y)
	if altura_necessaria > area_disponivel_y and maquinas_por_linha < 12:
		# Aumenta máquinas por linha para reduzir linhas
		maquinas_por_linha = min(12, maquinas_por_linha + 2)
		linhas_necessarias = ceil(float(num_maquinas) / float(maquinas_por_linha))
		altura_necessaria = linhas_necessarias * (maquina_size.y + espacamento.y)
	
	# Ajusta espaçamento vertical se ainda não cabe
	var espacamento_y_ajustado = espacamento.y
	if altura_necessaria > area_disponivel_y:
		espacamento_y_ajustado = max(20, (area_disponivel_y - (linhas_necessarias * maquina_size.y)) / (linhas_necessarias + 1))

	# Cálculo de linha e coluna
	var coluna = total_maquinas_criadas % maquinas_por_linha
	var linha = total_maquinas_criadas / maquinas_por_linha
	
	# Posiciona a partir da margem esquerda
	var pos_x = margem_x + coluna * (maquina_size.x + espacamento.x)
	var pos_y = margem_y + linha * (maquina_size.y + espacamento_y_ajustado)

	maquina.position = Vector2(pos_x, pos_y)

	maquina.inicializar(dados)
	add_child(maquina)
	print(dados)
	total_maquinas_criadas += 1
	return maquina

func _deletar_funcionario(funcionario: Funcionario):
	if not is_instance_valid(funcionario):
		return
	
	var area = funcionario.get_node("Area2D")
	area.set_deferred("input_pickable", false)
	area.set_deferred("monitorable", false)
	area.set_deferred("monitoring", false)
	
	var sprite : Sprite2D = funcionario.get_child(0)
	var animation : AnimatedSprite2D = funcionario.get_child(1)
	var ui = funcionario.get_child(3)
	var button = ui.get_child(0)
	
	button.visible = false
	sprite.visible = false
	animation.visible = true
	
	print(funcionario.nome, " - iniciando animação de morte")
	animation.play("morte")
	
	var on_animation_finished = func():
		print(funcionario.nome, " - animação de morte concluída")
		deletar_funcionario(funcionario)
	
	if not animation.animation_finished.is_connected(on_animation_finished):
		animation.animation_finished.connect(on_animation_finished, CONNECT_ONE_SHOT)

func deletar_funcionario(funcionario: Funcionario):
	if not is_instance_valid(funcionario):
		return
		
	var almas_base = 1
	var almas_extras = 0
	
	# Checa se o funcionário tem o upgrade de almas extras
	if funcionario.has_meta("drop_alma_extra_chance"):
		var chance = funcionario.get_meta("drop_alma_extra_chance")
		var quantidade = funcionario.get_meta("drop_alma_extra_quantidade")
		if randf() <= chance:
			almas_extras = quantidade
			print(funcionario.nome, " dropou ", almas_extras, " almas extras!")
	
	alterar_almas(almas_base + almas_extras)
	
	for signal_dict in funcionario.get_incoming_connections():
		var signal_obj = signal_dict["signal"]
		if signal_obj.get_object().has_signal(signal_obj.get_name()):
			signal_obj.get_object().disconnect(signal_obj.get_name(), signal_dict["callable"])
	
	funcionario.queue_free()
	
func soma_maquinas_total(_dados = null):
	maquinas_totais += 1
	print("Máquinas em operação:", maquinas_totais)
	
func reduz_maquinas_total(_dados = null):
	maquinas_totais -= 1
	print("Máquinas em operação:", maquinas_totais)

func atualizar_dados(funcionario: Funcionario):
	funcionario.queue_free()

func checar_cota_alcancada():
	if cota > 0:
		print("Game Over")
	else:
		print("Cota alcançada")

# Callback quando funcionário morre - diminui fama
func _on_funcionario_morreu(_funcionario, _renda):
	var perda_fama = 3.0  # Perde 3 pontos de fama por morte
	alterar_fama(-perda_fama)
	print("Funcionário morreu! Fama: ", fama)

# Callback quando funcionário foge - diminui muito a fama
func _on_funcionario_fugiu(funcionario):
	var perda_fama = 15.0  # Perde 15 pontos de fama quando funcionário foge
	alterar_fama(-perda_fama)
	print(funcionario.nome, " fugiu! Fama caiu drasticamente: ", fama)
	
	# Remove funcionário da cena
	if is_instance_valid(funcionario):
		funcionario.queue_free()
