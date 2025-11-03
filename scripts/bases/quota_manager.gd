extends Node

const COTA_BASE = 0
var cotaAtual = 0

func _ready() -> void:
	EventBus.NOVA_COTA.connect(calcular_cota)

func calcular_cota():
	print("CALCULANDO COTA")
	var cotaRange = randi() % 1500 + 500
	cotaAtual =+ cotaRange
	$"..".cota = cotaAtual
	EventBus.CHECAR_COTA.emit(cotaAtual)
	pass
