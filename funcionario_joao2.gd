extends Node2D
var data = preload("res://funcionario_joao.tres")
func _ready() -> void:
	var funcionario_2 = preload("res://funcionario_joao2.tscn").instantiate()
	add_child(funcionario_2)
	funcionario_2.inicializacao(data)
	pass
