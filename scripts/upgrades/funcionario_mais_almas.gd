class_name funcionarioMaisAlmasUpgrade extends UpgradeData

@export var chance_adicional: float = 0.25
@export var almas_extras: int = 1

# Este upgrade modifica o comportamento de drop de almas
# A lógica precisa ser aplicada no momento da morte do funcionário
func aplicar_upgrade(alvo) -> void:
	if not (alvo is FuncionarioData or alvo is Funcionario):
		push_error("Alvo invalido! Tipo: ", alvo.get_class())
		return
	
	# Adiciona uma propriedade customizada para rastrear o upgrade
	if alvo is Funcionario:
		alvo.set_meta("drop_alma_extra_chance", chance_adicional)
		alvo.set_meta("drop_alma_extra_quantidade", almas_extras)
	elif alvo is FuncionarioData:
		# Para dados, podemos adicionar metadados também
		pass
