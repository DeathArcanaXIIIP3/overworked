extends Control

class_name JogadorGUI

@onready var jogadorRef: Jogador = $"../Jogador"
var timerGlobalRef: Timer
var horaAtual: int
var diaAtual: int

func _ready() -> void:
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.connect(atualizar_atributos)
	EventBus.ATUALIZAR_INVENTARIOS_GUI.connect(atualizar_inventario)
	pass

func atualizar_atributos():
	$Dinheiro.text = "Dinheiro:  " + str(jogadorRef.dinheiro) 
	$Almas.text = "Almas:  " + str(jogadorRef.almas) 
	$Fama.text = "Fama: " + str(jogadorRef.fama)
	$Tempo.text = "Tempo Atual: " + str(horaAtual) + ":00"
	$Dia.text = "Dia Atual: " + str(diaAtual)
	pass

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
	for itens in jogadorRef.inventarioMaquinas:
		botao = factory_botao(itens)
		$Inventario/Maquinas.add_child(botao)

func limpar_inventarios():
	for filho in $Inventario/Funcionarios.get_children():
		filho.queue_free()
	for filho in $Inventario/Maquinas.get_children():
		filho.queue_free()

func item_do_inventario_selecionado(itemSelecionado: Resource):
	EventBus.ITEM_SELECIONADO.emit(itemSelecionado)

func apagar_botao(botao: Button):
	botao.queue_free()
	pass

func _on_timer_timeout() -> void:
	if jogadorRef.maquinas_totais <= 0:
		return
	horaAtual += 1
	#Não é correto o dia atual atualizzar aqui, ele deveria atualizar no if de baixo, coloquei aqui só pro mes passar mais rapido
	
	
	if horaAtual % 24 == 0:
		horaAtual = 0
		diaAtual += 1
		verificar_fim_do_mes()

	atualizar_atributos()
	pass # Replace with function body.

func verificar_fim_do_mes():
	print(diaAtual)
	print("Entrou 1")
	if diaAtual == 1:
		print("Entrou 2")
		if jogadorRef.almas < 1:
			print("Entrou 3")
			get_tree().change_scene_to_file("res://cenas/GameOver.tscn")
		else:
			print("Entrou 4")
			print("Meta batida!")
			diaAtual = 1 # Reseta o mês
			jogadorRef.almas -= 1 # Paga a cota
			jogadorRef.emit_signal("ATUALIZAR_ATRIBUTOS_GUI") # Atualiza GUI


func _on_button_pressed() -> void:
	#INSIRA O UPGRADE (Resource) QUE QUER ADICIONAR AO INVENTARIO DO JOGADOR AQUI, (ENQUANTO A UI NAO TIVER PRONTA E OQ TEM PRA TESTAR)
	EventBus.UPGRADE_ADQUIRIDO.emit(load("res://resources/upgrades/maquina_2x_renda.tres"))
	pass # Replace with function body.
