extends CanvasLayer

var motivo: String = ""

func _ready() -> void:
	EventBus.GAME_OVER.connect(_on_game_over)
	$Panel.visible = false

func _on_game_over(razao: String):
	motivo = razao
	mostrar_game_over()

func mostrar_game_over():
	$Panel.visible = true
	get_tree().paused = true
	
	# Atualiza mensagem baseada no motivo
	match motivo:
		"descoberto":
			$Panel/VBoxContainer/Titulo.text = "VOCÊ FOI DESCOBERTO!"
			$Panel/VBoxContainer/Mensagem.text = "Sua fama chegou a 0. As autoridades descobriram seu esquema e você foi preso."
		"cota":
			$Panel/VBoxContainer/Titulo.text = "FALHA NA COTA!"
			$Panel/VBoxContainer/Mensagem.text = "Você não atingiu a cota mensal. A Morte não ficou satisfeita."
		_:
			$Panel/VBoxContainer/Titulo.text = "GAME OVER"
			$Panel/VBoxContainer/Mensagem.text = "Você falhou em sua missão."

func _on_reiniciar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cenas/menu.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()
