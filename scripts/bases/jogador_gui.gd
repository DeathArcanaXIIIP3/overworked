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
	start_New_Day()
	pass

func _process(_delta: float) -> void:
	$HUD/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
	pass

func atualizar_atributos():
	$HUD/Dinheiro.text = str(jogadorRef.dinheiro) 
	$HUD/Almas.text = str(jogadorRef.almas) 

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

func limpar_inventarios():
	for filho in $Inventario/Funcionarios.get_children():
		filho.queue_free()
	for filho in $Upgrades.get_children():
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
	if data.Hora == 24:
		data.Hora = 0
		timer.queue_free()
		atualizar_dia()
		start_New_Day()
		EventBus.FIM_DO_DIA.emit()
	elif data.Dia == 30:
		data.Dia = 0
		atualizar_mês()
		EventBus.FIM_DO_MES.emit()
	elif data.Mês == 12:
		data.Mês = 0
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
	textRect.mouse_entered.connect(toogleTooltip.bind(dados))
	textRect.mouse_exited.connect(toogleTooltip.bind(dados))
	return textRect

func connectWorkerToGUI(funcionario: Funcionario):
	var collision = funcionario.get_node("Area2D")
	collision.mouse_entered.connect(toogleWorkerStatus.bind(funcionario))
	collision.mouse_exited.connect(toogleWorkerStatus.bind(funcionario))
	EventBus.FUNCIONARIO_MORREU_NA_MAQUINA.connect(func (funcionarioAtual, _renda):
		toogleWorkerStatus(funcionarioAtual))
	EventBus.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.connect(func (_renda,funcionarioAtual):
		$Workers_Status.visible = !$Workers_Status.visible
		toogleWorkerStatus(funcionarioAtual))
	EventBus.MEDO_MAXIMO_ATINGIDO.connect(func (funcionarioAtual):
		$Workers_Status.visible = !$Workers_Status.visible
		toogleWorkerStatus(funcionarioAtual))

func toogleTooltip(dados: Resource):
	$Tooltips.visible =! $Tooltips.visible
	$Tooltips.position = globalMousePosition
	$Tooltips/RichTextLabel.text = dados.description

func toogleWorkerStatus(funcionario: Funcionario):
	var mousePos2DtoControl = get_viewport().get_mouse_position()
	$Workers_Status.visible =! $Workers_Status.visible
	$Workers_Status.position = mousePos2DtoControl
	$Workers_Status/RichTextLabel.text = "Medo: " + str(funcionario.medo) + "\n" + "Produtividade: " + str(funcionario.getProdutividade()) + "\n" + "Risco: " + str(funcionario.getTaxaDeSobrevivencia())
