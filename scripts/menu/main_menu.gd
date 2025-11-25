extends Control

func _ready() -> void:
	$VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$VBoxContainer/OptionsButton.pressed.connect(_on_options_pressed)
	$VBoxContainer/CreditsButton.pressed.connect(_on_credits_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)
	
	$OptionsPanel.visible = false
	$CreditsPanel.visible = false

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/main.tscn")

func _on_options_pressed() -> void:
	$OptionsPanel.visible = true
	$VBoxContainer.visible = false

func _on_credits_pressed() -> void:
	$CreditsPanel.visible = true
	$VBoxContainer.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_to_menu() -> void:
	$OptionsPanel.visible = false
	$CreditsPanel.visible = false
	$VBoxContainer.visible = true
