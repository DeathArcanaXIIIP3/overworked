extends Node2D

class_name Funcionario
var Nome: String
var Taxa_de_sobrevivencia: float
var Medo: float
var Produtividade: float 
var Preço_do_funcionario: int 

func inicializacao(data:FuncionarioData):
	Nome = data.Nome
	Taxa_de_sobrevivencia = data.Taxa_de_sobrevivencia
	Medo = data.Medo
	Produtividade = data.Produtividade
	Preço_do_funcionario = data.Preço_do_funcionario
	pass
