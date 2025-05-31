extends Node2D

var label  # variável para guardar o Label

func _ready():
	label = get_node("Label")  # pega o Label filho

func _process(delta):
	# Atualiza o texto do Label com o valor do contador do GlobalTimer
	label.text = "Tempo global: %d" % GlobalTimer.contador
