extends Node

#----------Sinais das Maquinas------------#

class SinaisMaquinas:
	signal FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA
	signal FUNCIONARIO_MORREU_NA_MAQUINA
	signal FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA
	
	func on_funcionario_começou_a_operar_maquina():
		FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA.emit()
	func on_funcionario_morreu_na_maquina():
		FUNCIONARIO_MORREU_NA_MAQUINA.emit()
	func on_funcionario_parou_de_operar_maquina():
		FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.emit()


var SMaquinas = SinaisMaquinas.new()
