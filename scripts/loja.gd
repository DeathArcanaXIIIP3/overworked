extends TabContainer

class_name Loja

signal COMPRA_SOLICITADA
signal ATUALIZAR_INVENTARIO

var listaFuncionarios : Array[FuncionarioData]
var listaMaquinas : Array[MaquinaData]

func _ready() -> void:
	adicionar_funcionario_loja(load("res://resources/funcionarios/Fulana.tres"))
	adicionar_funcionario_loja(load("res://resources/funcionarios/Fulano.tres"))
	adicionar_maquina_loja(load("res://resources/maquinas/Maquina_De_Impressão.tres"))
	pass

func adicionar_funcionario_loja(funcionarioData: FuncionarioData):
	if !funcionarioData in listaFuncionarios:
		listaFuncionarios.append(funcionarioData)

func adicionar_maquina_loja(maquinaData: MaquinaData):
	if !maquinaData in listaMaquinas:
		listaMaquinas.append(maquinaData)
		ATUALIZAR_INVENTARIO.emit()

func factory_botao(dados: Resource):
	var botao = Button.new()
	botao.name = dados.nome
	botao.text = dados.nome
	botao.pressed.connect(solicitar_compra.bind(dados))
	return botao

func apagar_botao(botao: Button):
	botao.queue_free()
	pass

func solicitar_compra(itemSolicitado):
	COMPRA_SOLICITADA.emit(itemSolicitado)

func remover_item_da_loja(itemComprado):
	if itemComprado == null:
		push_warning("Item comprado NULL")
	elif itemComprado is FuncionarioData:
		listaFuncionarios.erase(itemComprado)
	elif itemComprado is MaquinaData:
		listaMaquinas.erase(itemComprado)
	atualizar_inventarios()

func atualizar_inventarios():
	limpar_inventarios()
	listar_inventarios()

func limpar_inventarios():
	for filho in $Funcionarios.get_children():
		filho.queue_free()
	for filho in $Maquinas.get_children():
		filho.queue_free()

func listar_inventarios():
	var botao : Button
	for itens in listaFuncionarios:
		botao = factory_botao(itens)
		$Funcionarios.add_child(botao)
	for itens in listaMaquinas:
		botao = factory_botao(itens)
		$Maquinas.add_child(botao)

func _on_atualizar_inventario() -> void:
	atualizar_inventarios()
	pass # Replace with function body.
