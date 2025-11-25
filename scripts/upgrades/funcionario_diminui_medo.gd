class_name funcionarioDiminuiMedoUpgrade extends UpgradeData

@export var percentual_reducao: float = 0.1

func aplicar_upgrade(alvo) -> void:
	if not (alvo is FuncionarioData or alvo is Funcionario):
		push_error("Alvo invalido! Tipo: ", alvo.get_class())
		return
	
	# FuncionarioData usa taxa_de_medo, Funcionario usa taxaDeMedo
	if alvo is FuncionarioData:
		var novoValor = alvo.taxa_de_medo * (1.0 - percentual_reducao)
		alvo.taxa_de_medo = novoValor
	elif alvo is Funcionario:
		var novoValor = alvo.taxaDeMedo * (1.0 - percentual_reducao)
		alvo.taxaDeMedo = novoValor
