extends Node2D

class_name funcionario
var Taxa_de_sobrevivencia
var Medo: float
var Produtividade: float 
var Preço_do_funcionario: int 
var data
var temp = preload("res://funcionario_joao.tres")
func inicializacao(data:FuncionarioData):
	self.Taxa_de_sobrevivencia = data.Taxa_de_sobrevivencia
	pass

	
	
