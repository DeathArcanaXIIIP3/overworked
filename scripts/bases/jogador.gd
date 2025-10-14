extends Node

class_name Jogador

@onready var jogadorGUIRef: JogadorGUI = $"../Jogador_GUI"

var nome: String = "Maritaca"
var almas: int = 0
var dinheiro: int = 2000
var fama: float = 0.1
var inventarioMaquinas: Array[MaquinaData]
var inventarioFuncionarios: Array[FuncionarioData]
var inventarioUpgrades: Array[UpgradeData]

var screenSize
var espacamento = Vector2(80, 60) 
var maquina_size = Vector2(120, 120) 
var maquinas_por_linha
var total_maquinas_criadas = 0
var maquinas_totais = 0

func _ready():
	#EventBus.FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA.connect(Callable(self,"soma_maquinas_total"))
	#EventBus.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.connect(reduz_maquinas_total)
	screenSize = get_viewport().size
	maquinas_por_linha = int((screenSize.x - espacamento.x) / (maquina_size.x + espacamento.x))
	pass

func adicionar_upgrade(itemRecebido: Resource):
	if itemRecebido == null:
		push_warning("Item recebido tipo NULL")
	elif itemRecebido is UpgradeData:
		inventarioUpgrades.append(itemRecebido)
		ativar_upgrade(itemRecebido)

func ativar_upgrade(upgrade: UpgradeData):
	var lojaRef: Loja = jogadorGUIRef.get_node("Loja")
	var filhosJogador: Array = self.get_children()
	if upgrade == null:
		push_warning("Upgrade recebido tipo NULL")
	elif upgrade is maquinaUpgrade:
		for n in inventarioMaquinas.size():
			print("Renda: ",inventarioMaquinas[n].renda)
			upgrade.aplicar_upgrade(inventarioMaquinas[n])
			print("Nova Renda: ",inventarioMaquinas[n].renda)
		for n in lojaRef.listaMaquinas.size():
			print("Renda: ",lojaRef.listaMaquinas[n].renda)
			upgrade.aplicar_upgrade(lojaRef.listaMaquinas[n])
			print("Nova Renda: ",lojaRef.listaMaquinas[n].renda)
		for n in filhosJogador.size():
			if filhosJogador[n] is Maquina:
				print("Renda: ",filhosJogador[n].renda)
				upgrade.aplicar_upgrade(filhosJogador[n])
				print("Nova Renda: ",filhosJogador[n].renda)
	elif upgrade is funcionarioUpgrade:
		for n in inventarioFuncionarios.size():
			print("Produtivdade: ",inventarioFuncionarios[n].produtividade)
			upgrade.aplicar_upgrade(inventarioFuncionarios[n])
			print("Nova Produtivdade: ",inventarioFuncionarios[n].produtividade)
		for n in lojaRef.listaFuncionarios.size():
			print("Produtivdade: ",lojaRef.listaFuncionarios[n].produtividade)
			upgrade.aplicar_upgrade(lojaRef.listaFuncionarios[n])
			print("Nova Produtivdade: ",lojaRef.listaFuncionarios[n].produtividade)
		for n in filhosJogador.size():
			if filhosJogador[n] is Funcionario:
				print("Produtivdade: ",filhosJogador[n].produtividade)
				upgrade.aplicar_upgrade(filhosJogador[n])
				print("Nova Produtivdade: ",filhosJogador[n].produtividade)
	pass
	
#func ativar_upgrade_funcionario(upgrade: funcionarioUpgrade):
	#var lojaRef: Loja = jogadorGUIRef.get_node("Loja")
	#var filhosJogador: Array = self.get_children()
	#for n in inventarioFuncionarios.size():
		#print("Produtivdade: ",inventarioFuncionarios[n].produtividade)
		#upgrade.aplicar_upgrade(inventarioFuncionarios[n])
		#print("Nova Produtivdade: ",inventarioFuncionarios[n].produtividade)
	#for n in lojaRef.listaFuncionarios.size():
		#print("Produtivdade: ",lojaRef.listaFuncionarios[n].produtividade)
		#upgrade.aplicar_upgrade(lojaRef.listaFuncionarios[n])
		#print("Nova Produtivdade: ",lojaRef.listaFuncionarios[n].produtividade)
	#for n in filhosJogador.size():
		#if filhosJogador[n] is Funcionario:
			#print("Produtivdade: ",filhosJogador[n].produtividade)
			#upgrade.aplicar_upgrade(filhosJogador[n])
			#print("Nova Produtivdade: ",filhosJogador[n].produtividade)
	#pass

func definir_Nome(novoNome: String):
	nome = novoNome
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.emit()
	return nome

func alterar_dinheiro(novoValor: int):
	dinheiro += novoValor
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.emit()
	return dinheiro

func alterar_fama(novoValor: float):
	fama += novoValor
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.emit()
	return fama

func alterar_almas(novoValor: int):
	almas += novoValor
	EventBus.ATUALIZAR_ATRIBUTOS_GUI.emit()
	return almas

func consultar_saldo_para_compra(itemSolicitado: Resource):
	if itemSolicitado.preco <= dinheiro:
		adicionar_ao_inventario(itemSolicitado)
		alterar_dinheiro(-itemSolicitado.preco)
		EventBus.COMPRA_REALIZADA.emit(itemSolicitado)
	else:
		print("SALDO INSUFICIENTE")

func adicionar_ao_inventario(itemRecebido: Resource):
	if itemRecebido == null:
		push_warning("Item recebido tipo NULL!")
	elif itemRecebido is FuncionarioData:
		inventarioFuncionarios.append(itemRecebido)
	elif MaquinaData:
		inventarioMaquinas.append(itemRecebido)
	EventBus.ATUALIZAR_INVENTARIOS_GUI.emit()

func remover_do_inventario(itemSelecionado: Resource):
	if itemSelecionado == null:
		push_warning("Item selecionado tipo NULL!")
	elif itemSelecionado is FuncionarioData:
		inventarioFuncionarios.erase(itemSelecionado)
	elif itemSelecionado is MaquinaData:
		inventarioMaquinas.erase(itemSelecionado)
	EventBus.ATUALIZAR_INVENTARIOS_GUI.emit()

func instanciar_objetos(dados: Resource):
	if dados == null:
		push_warning("Resource NULL")
	elif dados is FuncionarioData:
		remover_do_inventario(dados)
		return factory_funcionario(dados)
	elif dados is MaquinaData:
		remover_do_inventario(dados)
		return factory_maquina(dados)

func factory_funcionario(dados: FuncionarioData):
	var funcionario = preload("res://cenas/funcionario.tscn").instantiate()
	funcionario.name = dados.nome
	
	EventBus.MEDO_MAXIMO_ATINGIDO.connect(func(funcionario_atual):
		atualizar_dados(funcionario_atual)
		alterar_fama(-0.1))
	EventBus.PEDIR_RETORNO_PARA_INVENTARIO.connect(func(f):
		retornar_funcionario_para_inventario(f))

	add_child(funcionario)
	funcionario.setup(dados)
	funcionario.global_position = Vector2(screenSize[0]/2, screenSize[1]/2)
	return funcionario
	
func retornar_funcionario_para_inventario(funcionario: Funcionario):
	var dados = FuncionarioData.new()
	dados.nome = funcionario.nome
	dados.produtividade = funcionario.produtividade
	dados.preco = funcionario.preco
	dados.taxa_de_acidente = funcionario.taxaDeAcidente
	dados.taxa_de_medo = funcionario.taxaDeMedo
	dados.isDisponivel = true
	dados.profilePicture = funcionario.profilePicture
		
	adicionar_ao_inventario(dados)
	funcionario.queue_free()


func factory_maquina(dados: MaquinaData):
	var maquina = preload("res://cenas/maquina.tscn").instantiate()
	maquina.name = dados.nome
	
	EventBus.FUNCIONARIO_MORREU_NA_MAQUINA.connect(func (funcionario, renda): 
		
		reduz_maquinas_total(maquina)
		_deletar_funcionario(funcionario)
		alterar_dinheiro(renda))
	
	EventBus.FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA.connect(func (renda, funcionario):
		print("FUNCIONARIO PAROU DE OPERAR")
		reduz_maquinas_total(maquina)
		alterar_dinheiro(renda)
		funcionario.atualizarMedo())
	if maquinas_totais < 0:
		maquinas_totais = 0
		

	# Cálculo de linha e coluna
	var coluna = total_maquinas_criadas % maquinas_por_linha
	var linha = total_maquinas_criadas / maquinas_por_linha

	# Largura total ocupada pelas máquinas em uma linha
	@warning_ignore("unused_variable")
	var largura_total = maquinas_por_linha * (maquina_size.x + espacamento.x)
	# Ponto de início X centralizado
	var inicio_x = 400
	var pos_x = inicio_x + coluna * (maquina_size.x + espacamento.x)
	var pos_y = (screenSize.y / 2) + linha * (maquina_size.y + espacamento.y)

	maquina.position = Vector2(pos_x, pos_y)

	maquina.inicializar(dados)
	add_child(maquina)
	print(dados)
	total_maquinas_criadas += 1
	return maquina

func _deletar_funcionario(funcionario: Funcionario):
	var sprite : Sprite2D 
	var animation : AnimatedSprite2D
	animation = funcionario.get_child(1)
	sprite = funcionario.get_child(0)
	sprite.visible = false
	animation.visible = true
	animation.play("morte")
	animation.animation_finished.connect(func():deletar_funcionario(funcionario))

func deletar_funcionario(funcionario: Funcionario):
	alterar_almas(+1)
	funcionario.queue_free()
	
	
func soma_maquinas_total(_dados = null):
	maquinas_totais += 1
	print("Máquinas em operação:", maquinas_totais)
	
func reduz_maquinas_total(_dados = null):
	maquinas_totais -= 1
	print("Máquinas em operação:", maquinas_totais)

func atualizar_dados(funcionario: Funcionario):
	funcionario.queue_free()
