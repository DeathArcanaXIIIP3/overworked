class_name maquinaDiminuiTempoUpgrade extends UpgradeData

@export var percentual_reducao: float = 0.1

func aplicar_upgrade(alvo) -> void:
	if not (alvo is MaquinaData or alvo is Maquina):
		push_error("Alvo invalido! Tipo: ", alvo.get_class())
		return
	
	var novoValor = alvo.tempoDeExecução * (1.0 - percentual_reducao)
	alvo.tempoDeExecução = roundi(novoValor)
	
	# Se for instância de Maquina, atualiza também a barra de progresso
	if alvo is Maquina:
		alvo.get_node("Control/ProgressBar").max_value = alvo.tempoDeExecução
