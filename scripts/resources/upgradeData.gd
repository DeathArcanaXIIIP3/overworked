extends Resource

class_name UpgradeData

@export var nome: String
@export var icone: Texture

@warning_ignore("unused_parameter")
func aplicar_upgrade(alvo) -> void:
	push_error("aplicar_upgrade() não implementado em %s" %self)
	pass
