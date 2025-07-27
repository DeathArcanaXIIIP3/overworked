extends Control

@onready var botaoReiniciar = $Button

func _ready():
	botaoReiniciar.pressed.connect(_on_botao_reiniciar)

func _on_botao_reiniciar():
	get_tree().change_scene_to_file("res://cenas/main.tscn")
