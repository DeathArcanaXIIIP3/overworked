extends Node

enum GENDER {FEMALE,MALE}
enum QUALIFICATION {BAD,NEUTRAL,GOOD}
var generatedWorkers: Array[FuncionarioData]
var maleWorkersNames: Array[String] = ["Jonas","Kleber","Thomas","Caio","Leonardo","Lorenzo","Gabriel"]
var femaleWorkersNames: Array[String] = ["Ana","Laura","Lauren","Louise","Juliana","Fernanda","Jéssica"]
var resourceFuncionariosPath: String = "res://resources/funcionarios/"

func _ready() -> void:
	EventBus.FIM_DO_DIA.connect(generate_Workers)
	generate_Workers()

func generate_Workers():
	var gender = randi() % GENDER.size()
	var qualification = randi() % QUALIFICATION.size()
	var funcionario = FuncionarioData.new()
	
	match gender:
		GENDER.MALE:
			print("MALE")
			funcionario.profilePicture = load("res://sprites/funcionarios/Fulano.png")
			funcionario.nome = maleWorkersNames[randi() % maleWorkersNames.size()]
		GENDER.FEMALE:
			print("FEMALE")
			funcionario.profilePicture = load("res://sprites/funcionarios/Fulana.png")
			funcionario.nome = femaleWorkersNames[randi() % femaleWorkersNames.size()]
	
	funcionario = calcular_status(qualification,funcionario)
	print(funcionario.nome)
	salvar_tres(funcionario, resourceFuncionariosPath)
	EventBus.NOVO_FUNCIONARIO_GERADO.emit(funcionario)
	pass

func calcular_status(qualification, funcionarioData):
	match qualification:
		QUALIFICATION.BAD:
			var score = randi_range(1,3)
			var funcionario = aplicar_status(score,funcionarioData)
			return funcionario
		QUALIFICATION.NEUTRAL:
			var score = randi_range(4,7)
			var funcionario = aplicar_status(score,funcionarioData)
			return funcionario
		QUALIFICATION.GOOD:
			var score = randi_range(8,10)
			var funcionario = aplicar_status(score,funcionarioData)
			return funcionario
			
	pass

func aplicar_status(score: int, funcionarioData: FuncionarioData):
	funcionarioData.isDisponivel = true
	funcionarioData.preco = score * 100
	funcionarioData.produtividade = (score / 10.0)
	funcionarioData.taxa_de_acidente = (10 - score) / 10.0
	funcionarioData.taxa_de_medo =  (10 - score) / 10.0
	return funcionarioData

func salvar_tres(funcionario: FuncionarioData, path: String):
	path = path + funcionario.nome + ".tres"
	var erro = ResourceSaver.save(funcionario,path)
	if erro == OK:
		print("Salvo", path)
	else:
		push_error("Erro ao salvar", erro)
