extends CanvasLayer

var is_paused = false

func _ready() -> void:
	$Panel.visible = false
	$OptionsPanel.visible = false
	$Panel/VBoxContainer/ResumeButton.pressed.connect(_on_resume_pressed)
	$Panel/VBoxContainer/OptionsButton.pressed.connect(_on_options_pressed)
	$Panel/VBoxContainer/MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$Panel/VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)
	
	# Conecta o botão de voltar do painel de opções
	if $OptionsPanel.has_method("connect_back_button"):
		$OptionsPanel.connect_back_button(_on_options_back)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		# Se o painel de opções estiver aberto, volta ao menu de pausa
		if $OptionsPanel.visible:
			_on_options_back()
		else:
			toggle_pause()

func toggle_pause() -> void:
	is_paused = !is_paused
	$Panel.visible = is_paused
	get_tree().paused = is_paused

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_options_pressed() -> void:
	$Panel.visible = false
	$OptionsPanel.visible = true

func _on_options_back() -> void:
	$OptionsPanel.visible = false
	$Panel.visible = true

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://cenas/menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
