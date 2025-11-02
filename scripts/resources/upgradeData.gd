extends Resource

class_name UpgradeData

@export var nome: String
@export var icone: Texture
@export var ativo: bool
@export var preco: int
@export var description: String

@warning_ignore("unused_parameter")
func aplicar_upgrade(alvo) -> void:
	push_error("aplicar_upgrade() não implementado em %s" %self)
	pass
