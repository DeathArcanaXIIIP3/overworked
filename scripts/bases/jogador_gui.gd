extends Control

class_name JogadorGUI

@onready var jogadorRef: Jogador = $"../Jogador"
var data = {
	"Dia" : 1,
	"Mês" : 1,
	"Ano" : 2025,
	"Hora": 0
}

func _ready() -> void:
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.connect(atualizar_atributos)
	EventBus.ATUALIZAR_INVENTARIOS_GUI.connect(atualizar_inventario)
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

func listar_upgrades_adquiridos():
	pass

func listar_inventarios():
	var botao : Button
	for itens in jogadorRef.inventarioFuncionarios:
		botao = factory_botao(itens)
		$Inventario/Funcionarios.add_child(botao)

func limpar_inventarios():
	for filho in $Inventario/Funcionarios.get_children():
		filho.queue_free()

func item_do_inventario_selecionado(itemSelecionado: Resource):
	EventBus.ITEM_SELECIONADO.emit(itemSelecionado)

func apagar_botao(botao: Button):
	botao.queue_free()
	pass

func _on_button_pressed() -> void:
	#INSIRA O UPGRADE (Resource) QUE QUER ADICIONAR AO INVENTARIO DO JOGADOR AQUI, (ENQUANTO A UI NAO TIVER PRONTA E OQ TEM PRA TESTAR)
	EventBus.UPGRADE_ADQUIRIDO.emit(load("res://resources/upgrades/maquina_2x_renda.tres"))

	pass # Replace with function body.


func _on_funcionario_button_pressed() -> void:
	EventBus.UPGRADE_ADQUIRIDO.emit(load("res://resources/upgrades/funcionario_2x_produtividade.tres"))
	pass # Replace with function body.


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
	elif data.Dia == 30:
		data.Dia = 0
		atualizar_mês()
	elif data.Mês == 12:
		data.Mês = 0
	pass

func start_New_Day():
	var timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.start(20.0)
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
