extends Control

class_name JogadorGUI

@onready var jogadorRef: Jogador = $"../Jogador"

var globalMousePosition: Vector2

var data = {
	"Dia" : 1,
	"Mês" : 1,
	"Ano" : 2025,
	"Hora": 0
}

func _ready() -> void:
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.connect(atualizar_atributos)
	EventBus.ATUALIZAR_INVENTARIOS_GUI.connect(atualizar_inventario)
	EventBus.CHECAR_COTA.connect(atualizar_cota)
	EventBus.COTA_ALCANCADA.connect(skip_day)
	EventBus.ATUALIZAR_COTA_GUI.connect(atualizar_cota)
	EventBus.FUNCIONARIO_ENTROU_NA_CENA.connect(connectWorkerToGUI)
	EventBus.COMPRA_REALIZADA.connect(_on_compra_realizada)
	setup_hud_tooltips()
	start_New_Day()
	pass

func _process(_delta: float) -> void:
	$HUD/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	globalMousePosition = get_viewport().get_mouse_position()
	pass

func setup_hud_tooltips():
	# Conecta tooltips para os ícones do HUD
	setup_icon_tooltip($HUD/AlmasIconGUI, "Almas: Moeda especial obtida quando funcionários morrem. Usada para comprar upgrades.")
	setup_icon_tooltip($HUD/DinheiroIconGUI, "Dinheiro: Moeda principal usada para comprar máquinas e contratar funcionários.")
	setup_icon_tooltip($HUD/FamaIconGUI, "Fama: Reputação da sua empresa (0-100). Cai quando funcionários morrem ou fogem. GAME OVER se chegar a 0!")
	setup_icon_tooltip($HUD/TempoIconGUI, "Tempo: Hora atual do dia. Cada dia tem 24 horas.")
	setup_icon_tooltip($HUD/DiaIconGUI, "Dia: Dia atual do mês. O mês tem 30 dias.")
	setup_icon_tooltip($HUD/CotaIconGUI, "Cota: Meta de produção que deve ser alcançada até o fim do mês.")

func setup_icon_tooltip(icon: TextureRect, description: String):
	icon.mouse_filter = Control.MOUSE_FILTER_PASS
	icon.mouse_entered.connect(func():
		show_simple_tooltip(description))
	icon.mouse_exited.connect(func():
		hide_simple_tooltip())

func show_simple_tooltip(text: String):
	$Tooltips.visible = true
	$Tooltips.position = globalMousePosition
	$Tooltips/RichTextLabel.text = text

func hide_simple_tooltip():
	$Tooltips.visible = false

func atualizar_atributos():
	var old_dinheiro = int($HUD/Dinheiro.text)
	var old_almas = int($HUD/Almas.text)
	var old_fama = float($HUD/Fama.text) if $HUD/Fama.text != "" else jogadorRef.fama
	
	$HUD/Dinheiro.text = str(jogadorRef.dinheiro)
	$HUD/Almas.text = str(jogadorRef.almas)
	$HUD/Fama.text = str(snapped(jogadorRef.fama, 0.1))
	
	# Anima se o valor mudou
	if jogadorRef.dinheiro != old_dinheiro:
		animate_value_change($HUD/Dinheiro, jogadorRef.dinheiro > old_dinheiro)
	if jogadorRef.almas != old_almas:
		animate_value_change($HUD/Almas, jogadorRef.almas > old_almas)
	if abs(jogadorRef.fama - old_fama) > 0.1:
		animate_value_change($HUD/Fama, jogadorRef.fama > old_fama)
		
		# Alerta visual se fama crítica
		if jogadorRef.fama <= 20:
			$HUD/Fama.modulate = Color.RED
		elif jogadorRef.fama <= 40:
			$HUD/Fama.modulate = Color.ORANGE
		else:
			$HUD/Fama.modulate = Color.WHITE 

func atualizar_inventario():
	limpar_inventarios()
	listar_inventarios()
	pass

func factory_botao(dados: Resource):
	var botao = Button.new()
	botao.name = dados.nome
	botao.text = dados.nome
	botao.pressed.connect(func():
		apagar_botao(botao)
		item_do_inventario_selecionado(dados)
		)
	return botao

func listar_inventarios():
	var botao : Button
	for itens in jogadorRef.inventarioFuncionarios:
		botao = factory_botao(itens)
		$Inventario/Funcionarios.add_child(botao)
	for itens in jogadorRef.inventarioUpgrades:
		var textureRect: TextureRect
		textureRect = factory_Text_Rect(itens)
		$Upgrades.add_child(textureRect)
		# Anima o novo upgrade quando adicionado
		textureRect.scale = Vector2.ZERO
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_BACK)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(textureRect, "scale", Vector2.ONE, 0.4)
	
	# Adiciona decorações ao inventário
	print("DEBUG: inventarioDecoracoes tem ", jogadorRef.inventarioDecoracoes.size(), " itens")
	if has_node("Inventario/Decorações"):
		print("DEBUG: Aba Decorações encontrada!")
		for itens in jogadorRef.inventarioDecoracoes:
			print("DEBUG: Adicionando decoração: ", itens.nome)
			botao = factory_botao_decoracao(itens)
			$"Inventario/Decorações".add_child(botao)
	elif has_node("Inventario/Decoracoes"):
		print("DEBUG: Aba Decoracoes encontrada!")
		for itens in jogadorRef.inventarioDecoracoes:
			print("DEBUG: Adicionando decoração: ", itens.nome)
			botao = factory_botao_decoracao(itens)
			$"Inventario/Decoracoes".add_child(botao)
	else:
		print("DEBUG: Aba Decorações/Decoracoes NÃO encontrada - verifique a estrutura da cena")

func factory_botao_decoracao(dados: DecoracaoData):
	var botao = Button.new()
	botao.name = dados.nome
	botao.text = "%s\n+%.0f Fama" % [dados.nome, dados.fama_bonus]
	botao.tooltip_text = "Clique para colocar no jogo"
	botao.pressed.connect(func():
		apagar_botao(botao)
		item_do_inventario_selecionado(dados)
	)
	return botao

func limpar_inventarios():
	for filho in $Inventario/Funcionarios.get_children():
		filho.queue_free()
	for filho in $Upgrades.get_children():
		filho.queue_free()
	if has_node("Inventario/Decorações"):
		for filho in $"Inventario/Decorações".get_children():
			filho.queue_free()
	elif has_node("Inventario/Decoracoes"):
		for filho in $"Inventario/Decoracoes".get_children():
			filho.queue_free()

func item_do_inventario_selecionado(itemSelecionado: Resource):
	EventBus.ITEM_SELECIONADO.emit(itemSelecionado)

func apagar_botao(botao: Button):
	botao.queue_free()
	pass

func _on_swap_button_pressed() -> void:
	disable_swap_button()
	swap_GUI_elements_position($Loja,$Upgrades)
	pass # Replace with function body.

func swap_GUI_elements_position(elementX: Control, elementY: Control):
	var tweenElementX = create_tween()
	var tweenElementY = create_tween()
	var elementXOriginalPos = elementX.position
	var elementYOriginalPos = elementY.position
	
	tweenElementX.set_trans(Tween.TRANS_SINE)
	tweenElementY.set_trans(Tween.TRANS_SINE)
	
	tweenElementX.tween_property(elementX,"position",elementYOriginalPos, 1.0)
	tweenElementY.tween_property(elementY,"position",elementXOriginalPos, 1.0)
	
	tweenElementX.finished.connect(self.disable_swap_button)
	pass

func disable_swap_button():
	$SwapButton.disabled = !$SwapButton.disabled

func calendarManager(timer: Timer):
	if data.Hora >= 24:
		data.Hora = 0
		timer.queue_free()
		EventBus.FIM_DO_DIA.emit()
		atualizar_dia()
		
		if data.Dia > 30:
			data.Dia = 1
			atualizar_mês()
			EventBus.FIM_DO_MES.emit()
			
			if data.Mês > 12:
				data.Mês = 1
				data.Ano += 1
		
		start_New_Day()
	pass

func skip_day():
	data.Hora = 24
	self.calendarManager($Timer_Data)

func start_New_Day():
	var timer = Timer.new()
	timer.name = "Timer_Data"
	add_child(timer)
	timer.one_shot = false
	timer.start(5.0)
	timer.timeout.emit()
	timer.timeout.connect(self.atualizar_hora)
	timer.timeout.connect(func(): self.calendarManager(timer))
	pass
	
func atualizar_hora():
	data.Hora += 1
	$HUD/Tempo.text = str(data.Hora) + (":00")

func atualizar_dia():
	data.Dia += 1
	$HUD/Dia.text = str(data.Dia) 
	
func atualizar_mês():
	data.Mês += 1
	print(data.Mês)

func atualizar_cota(cota:int):
	$HUD/Cota.text = str(cota)


func factory_Text_Rect(dados: Resource):
	var textRect = TextureRect.new()
	textRect.texture = dados.icone
	textRect.custom_minimum_size = Vector2(64, 64)
	textRect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	textRect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	textRect.mouse_entered.connect(toogleTooltip.bind(dados))
	textRect.mouse_exited.connect(toogleTooltip.bind(dados))
	textRect.pivot_offset = Vector2(32, 32)  # Centro para rotação
	return textRect

# Anima um ícone de upgrade individual
func animate_upgrade_icon(icon: TextureRect, delay: float = 0.0):
	await get_tree().create_timer(delay).timeout
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_parallel(true)
	
	# Escala pop
	icon.scale = Vector2(0.5, 0.5)
	tween.tween_property(icon, "scale", Vector2(1.2, 1.2), 0.3)
	
	# Rotação leve
	tween.tween_property(icon, "rotation", deg_to_rad(360), 0.5)
	
	# Brilho
	tween.tween_property(icon, "modulate", Color(1.5, 1.5, 1.5, 1.0), 0.2)
	
	# Volta ao normal
	tween.chain()
	tween.set_parallel(true)
	tween.tween_property(icon, "scale", Vector2(1.0, 1.0), 0.2)
	tween.tween_property(icon, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)

func connectWorkerToGUI(funcionario: Funcionario):
	var collision = funcionario.get_node("Area2D")
	
	var on_mouse_entered = func():
		if is_instance_valid(funcionario):
			$Workers_Status.visible = true
			toogleWorkerStatus(funcionario)
	
	var on_mouse_exited = func():
		$Workers_Status.visible = false
	
	collision.mouse_entered.connect(on_mouse_entered)
	collision.mouse_exited.connect(on_mouse_exited)
	
	EventBus.FUNCIONARIO_MORREU_NA_MAQUINA.connect(func (funcionarioAtual, _renda):
		if funcionarioAtual == funcionario:
			$Workers_Status.visible = false)
	
	EventBus.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.connect(func (_renda,funcionarioAtual):
		if funcionarioAtual == funcionario:
			$Workers_Status.visible = false)
	
	EventBus.MEDO_MAXIMO_ATINGIDO.connect(func (funcionarioAtual):
		if funcionarioAtual == funcionario:
			$Workers_Status.visible = false)

func toogleTooltip(dados: Resource):
	$Tooltips.visible =! $Tooltips.visible
	$Tooltips.position = globalMousePosition
	
	# Formata o texto com informações detalhadas baseado no tipo
	if dados is UpgradeData:
		$Tooltips/RichTextLabel.text = "[b]%s[/b]\n%s\n\n[color=gold]Preço: %d Almas[/color]" % [dados.nome, dados.description, dados.preco]
	elif dados is FuncionarioData:
		$Tooltips/RichTextLabel.text = "[b]%s[/b]\n\n[color=green]Preço: $%d[/color]\nProdutividade: %.1f\nTaxa de Medo: %.1f%%\nTaxa de Acidente: %.1f%%" % [
			dados.nome,
			dados.preco,
			dados.produtividade,
			dados.taxa_de_medo * 100,
			dados.taxa_de_acidente * 100
		]
	elif dados is MaquinaData:
		$Tooltips/RichTextLabel.text = "[b]%s[/b]\n\n[color=green]Preço: $%d[/color]\nRenda: $%d\nTempo: %ds" % [
			dados.nome,
			dados.preco,
			dados.renda,
			dados.tempoDeExecução
		]
	elif dados is DecoracaoData:
		$Tooltips/RichTextLabel.text = "[b]%s[/b]\n\n[color=green]Preço: $%d[/color]\n[color=cyan]Bônus de Fama: +%.1f[/color]\n\n%s" % [
			dados.nome,
			dados.preco,
			dados.fama_bonus,
			dados.description
		]
	else:
		$Tooltips/RichTextLabel.text = dados.description if dados.has("description") else dados.nome

func toogleWorkerStatus(funcionario: Funcionario):
	if not is_instance_valid(funcionario):
		$Workers_Status.visible = false
		return
	
	var mousePos2DtoControl = get_viewport().get_mouse_position()
	var status = "Trabalhando" if not funcionario.isDisponivel else "Livre"
	
	$Workers_Status.visible = true
	$Workers_Status.position = mousePos2DtoControl
	$Workers_Status/RichTextLabel.text = "[b]" + funcionario.nome + "[/b]\n" + "Status: " + status + "\n" + "Medo: " + str(snapped(funcionario.medo * 100, 0.1)) + "%\n" + "Taxa de Medo: " + str(snapped(funcionario.taxaDeMedo * 100, 0.1)) + "%\n" + "Produtividade: " + str(snapped(funcionario.getProdutividade(), 0.1)) + "\n" + "Risco: " + str(snapped(funcionario.getTaxaDeSobrevivencia() * 100, 0.1)) + "%"

# Animação quando valores mudam (dinheiro/almas)
func animate_value_change(label: Label, is_positive: bool):
	var color = Color.GREEN if is_positive else Color.RED
	var original_color = label.modulate
	
	# Cria animação de escala e cor
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	
	# Escala
	tween.tween_property(label, "scale", Vector2(1.3, 1.3), 0.2)
	tween.tween_property(label, "modulate", color, 0.2)
	
	# Volta ao normal
	tween.chain()
	tween.set_parallel(true)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.3)
	tween.tween_property(label, "modulate", original_color, 0.3)

# Callback quando uma compra é realizada
func _on_compra_realizada(item: Resource):
	if item is UpgradeData:
		animate_upgrade_purchase()

# Animação quando um upgrade é comprado
func animate_upgrade_purchase():
	var upgrades_container = $Upgrades
	
	# Flash no container de upgrades
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Pulso de cor dourada
	var original_modulate = upgrades_container.modulate
	tween.tween_property(upgrades_container, "modulate", Color(1.5, 1.3, 0.5, 1.0), 0.15)
	tween.tween_property(upgrades_container, "modulate", original_modulate, 0.3)
	
	# Anima cada upgrade individualmente com delay
	await get_tree().create_timer(0.2).timeout
	for i in upgrades_container.get_child_count():
		var child = upgrades_container.get_child(i)
		if child is TextureRect:
			animate_upgrade_icon(child, i * 0.05)
