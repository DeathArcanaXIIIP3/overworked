class_name maquinaUpgrade extends UpgradeData

@export var multiplicador: float

func aplicar_upgrade(alvo) -> void:
	if not (alvo is MaquinaData) and not (alvo is Maquina):
		push_error("Alvo invalido! Tipo: ", alvo.get_class())
	else:
		var novoValor = alvo.renda * multiplicador
		alvo.renda = roundi(novoValor)
