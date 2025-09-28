class_name funcionarioUpgrade extends UpgradeData

@export var multiplicador: float

func aplicar_upgrade(alvo) -> void:
	if not (alvo is FuncionarioData) and not (alvo is Funcionario):
		push_error("Alvo invalido! Tipo: ", alvo.get_class())
		return
	
	var novoValor = alvo.produtividade * multiplicador
	alvo.produtividade = novoValor
