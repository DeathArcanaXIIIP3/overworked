# TabContainer.gd
extends TabContainer

@onready var grade_funcionario = $Funcionarios/ScrollContainer/GridContainer
@onready var tab_maquina = $Maquinas
var cenabotao = preload("res://cenas/botao.tscn")

func _ready() -> void:
	
	for n in range(10):
		var newbotao = cenabotao.instantiate()
		grade_funcionario.add_child(newbotao)
