extends Node2D

class_name funcionario
var Taxa_de_sobrevivencia: float
var Medo: float
var Produtividade: float 
var Preço_do_funcionario: int 

func inicializacao(data:FuncionarioData):
	Taxa_de_sobrevivencia = data.Taxa_de_sobrevivencia
	Medo = data.Medo
	Produtividade = data.Produtividade
	Preço_do_funcionario = data.Preço_do_funcionario
	pass
