extends Resource

class_name UpgradeData

@export var texture: Texture2D

func applyUpgrade(maquina: MaquinaData):
	var novoValor = maquina.renda * 2.0
	maquina.renda = round(novoValor)
	pass
