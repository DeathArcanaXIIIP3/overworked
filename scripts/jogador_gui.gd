extends Control

class_name JogadorGUI

var jogadorRef: Jogador

func atualizar_GUI():
	print("Atualizado")
	$Dinheiro.text = "Dinheiro:  " + str(jogadorRef.dinheiro) 
	$Almas.text = "Almas:  " + str(jogadorRef.almas) 
	$Fama.text = "Fama: " + str(jogadorRef.fama)
	pass

func atualizar_inventario_GUI(dados: Resource):
	var botão = Button.new()
	botão.text = dados.nome
	botão.pressed.connect(self.apagar_botão.bind(botão))
	if dados is FuncionarioData:
		botão.pressed.connect(jogadorRef.factory_funcionario.bind(dados))
		$Inventario/Funcionarios.add_child(botão)
	elif dados is MaquinaData:
		botão.pressed.connect(jogadorRef.factory_maquina.bind(dados))
		$Inventario/Maquinas.add_child(botão)
	pass

func apagar_botão(botão: Button):
	botão.queue_free()
	pass

func _on_jogador_funcionario_adicionado_ao_inventario(dados) -> void:
	atualizar_inventario_GUI(dados)
	pass # Replace with function body.


func _on_jogador_maquina_adicionado_ao_inventario(dados) -> void:
	atualizar_inventario_GUI(dados)
	pass # Replace with function body.


func _on_jogador_dinheiro_alterado() -> void:
	atualizar_GUI()
	pass # Replace with function body.


func _on_jogador_almas_alterada() -> void:
	atualizar_GUI()
	pass # Replace with function body.


func _on_jogador_fama_alterada() -> void:
	atualizar_GUI()
	pass # Replace with function body.
