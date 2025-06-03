extends Control

class_name JogadorGUI

signal ITEM_SELECIONADO

@onready var jogadorRef: Jogador = $"../Jogador"
var timerGlobalRef: Timer
var horaAtual: int
var diaAtual: int

func _ready() -> void:
	jogadorRef.ATUALIZAR_ATRIBUTOS_GUI.connect(atualizar_atributos)
	jogadorRef.ATUALIZAR_INVENTARIOS_GUI.connect(atualizar_inventario)
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
	ITEM_SELECIONADO.emit(itemSelecionado)

func apagar_botao(botao: Button):
	botao.queue_free()
	pass

func _on_timer_timeout() -> void:
	horaAtual += 1
	
	if horaAtual%24 == 0:
		horaAtual = 0
		diaAtual += 1
	
	atualizar_atributos()
	pass # Replace with function body.
