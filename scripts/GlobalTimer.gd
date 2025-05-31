extends Node2D

var label

func _ready():
	label = get_node("Label")
func _process(delta):
	# Atualiza o texto do Label com o valor do contador do GlobalTimer
	label.text = "Tempo global: %d" % GlobalTimer.contador
