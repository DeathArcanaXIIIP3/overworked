extends Node2D

class_name Funcionario

const LIMITE_MAX_MEDO = 1.0
const VALOR_MEDO_ALTO = LIMITE_MAX_MEDO - 0.2
const INCREMENTO_MEDO_PADRAO = 0.1
const OFFSET_BOTAO = Vector2(0, -40)

var nome: String
var medo: float
var produtividade: float
var preco: int

var medoTotal: int
var contrato: int
var chanceDeSobrevivencia: float
var profilePicture: Texture
#---Multiplicadores---#
var taxaDeMedo: float
var taxaDeAcidente: float
#--Booleanos pra validação de status--#
var isDisponivel: bool

func _ready():
	$UI/BotaoVoltar.pressed.connect(_voltar_para_inventario)
	$UI/BotaoVoltar.position = Vector2(100, 0)
	criar_barra_medo()
func _voltar_para_inventario():
	if isDisponivel:
		EventBus.PEDIR_RETORNO_PARA_INVENTARIO.emit(self)
	else:
		print(nome, " está ocupado e não pode retornar ao inventário.")

func setup(data:FuncionarioData):
	nome = data.nome
	preco = data.preco
	produtividade = data.produtividade
	
	taxaDeAcidente = data.taxa_de_acidente
	taxaDeMedo = data.taxa_de_medo
	
	isDisponivel = data.isDisponivel
	medo = 0.0
	
	profilePicture = data.profilePicture
	$Sprite.texture = data.profilePicture
	
func atualizar_posicao_do_botao():
	var offset = Vector2(0, 0) # ajuste a posição do botão relativo ao funcionário
	# Se o botão está dentro de UI (CanvasLayer ou Node2D filho)
	$UI/BotaoVoltar.position = to_local(global_position + offset)
# Getter para a produtividade
func getProdutividade() -> float:
	return produtividade

func isProdutividadeValida(valor: float) -> bool:
	return valor >= 0

func notificarErroProdutividade() -> void:
	print("A produtividade não pode ser negativa.")


# Setter para a produtividade
func setProdutividade(novaProdutividade: float) -> void:
	if isProdutividadeValida(novaProdutividade):
		produtividade = novaProdutividade
	else:
		notificarErroProdutividade()
		

# Checa a produtividade
func checarProdutividade(fator: float) -> float:
	return clamp(fator, 0, 100)

# Atualiza a produtividade
func atualizarProdutividade(fator: float) -> void:
	produtividade += fator
	produtividade = checarProdutividade(produtividade)
	notificarAtualizacaoProdutividade()

func notificarAtualizacaoProdutividade() -> void:
	print("Produtividade atualizada para: ", produtividade)

# Atualiza o medo para mais 10%
func incrementarMedo(incremento: float) -> void:
	medo += incremento
	medo = clamp(medo, 0, 1)
	
func checarMedoMaximo() -> bool:
	return medo >= LIMITE_MAX_MEDO
	
func atualizarMedo() -> void:
	incrementarMedo(getMultiplicadorDeMedo())
	print("Medo atualizado para: ", medo, " (", medo * 100, "%)")
	
	# Verifica se funcionário vai fugir baseado no medo
	if verificar_fuga_por_medo():
		return  # Funcionário fugiu, para execução aqui
	
	if checarMedoMaximo():
		EventBus.MEDO_MAXIMO_ATINGIDO.emit(self)

func verificar_fuga_por_medo() -> bool:
	# Rola um dado de 0 a 1
	var dado = randf()
	
	# Chance de fuga reduzida: apenas 40% do valor do medo
	# Exemplo: medo 50% = apenas 20% de chance real de fugir
	var chance_fuga = medo * 0.4
	
	# Se o dado for menor que a chance reduzida, funcionário foge
	if dado < chance_fuga:
		print(nome, " está com muito medo (", medo * 100, "%) e vai fugir! (chance: ", chance_fuga * 100, "%, dado: ", dado, ")")
		funcionario_foge()
		return true
	else:
		print(nome, " continua trabalhando apesar do medo (", medo * 100, "%) (chance: ", chance_fuga * 100, "%, dado: ", dado, ")")
		return false

# Getter para a taxa de sobrevivência
func getTaxaDeSobrevivencia() -> float:
	return taxaDeAcidente

# Setter para a taxa de sobrevivência
func isTaxaValida(valor: float) -> bool:
	return valor >= 0 and valor <= 1
	
func notificarTaxaInvalida() -> void:
	print("Taxa de sobrevivência inválida. Deve ser entre 0 e 1.")
	
func setTaxaDeSobrevivencia(novaTaxa: float) -> void:
	if isTaxaValida(novaTaxa):
		taxaDeAcidente = novaTaxa
	else:
		notificarTaxaInvalida()

# Getter para o preço do funcionário
func getPrecoDoFuncionario() -> int:
	return preco

# Setter para o preço do funcionário
func isPrecoValido(valor: int) -> bool:
	return valor >= 0
	
func notificarPrecoInvalido() -> void:
	print("O preço do funcionário não pode ser negativo.")
	
func setPrecoDoFuncionario(novoPreco: int) -> void:
	if isPrecoValido(novoPreco):
		preco = novoPreco
	else:
		notificarPrecoInvalido()

# Getter para o multiplicador de medo
func getMultiplicadorDeMedo() -> float:
	return taxaDeMedo

# Setter para o multiplicador de medo
func isMultiplicadorValido(valor: float) -> bool:
	return valor >= 0
	
func notificarMultiplicadorInvalido() -> void:
	print("O multiplicador de medo não pode ser negativo.")
	
func setMultiplicadorDeMedo(novoMultiplicador: float) -> void:
	if isMultiplicadorValido(novoMultiplicador):
		taxaDeMedo = novoMultiplicador
	else:
		notificarMultiplicadorInvalido()

# Getter para o medo total
func getMedoTotal() -> int:
	return medoTotal

# Setter para o medo total
func isMedoTotalValido(valor: int) -> bool:
	return valor >= 0
	
func notificarMedoTotalInvalido() -> void:
	print("O medo total não pode ser negativo.")
	
func setMedoTotal(novoMedoTotal: int) -> void:
	if isMedoTotalValido(novoMedoTotal):
		medoTotal = novoMedoTotal
	else:
		notificarMedoTotalInvalido()

# Getter para o contrato
func getContrato() -> int:
	return contrato

# Setter para o contrato
func isContratoValido(valor: int) -> bool:
	return valor >= 0

func notificarContratoInvalido() -> void:
	print("O contrato não pode ser negativo.")

func setContrato(novoContrato: int) -> void:
	if isContratoValido(novoContrato):
		contrato = novoContrato
	else:
		notificarContratoInvalido()


# Getter para a chance de sobrevivência
func getChanceDeSobrevivencia() -> float:
	return chanceDeSobrevivencia

# Setter para a chance de sobrevivência
func isChanceValida(valor: float) -> bool:
	return valor >= 0 and valor <= 1

func notificarChanceInvalida() -> void:
	print("Chance de sobrevivência inválida. Deve ser entre 0 e 1.")

func setChanceDeSobrevivencia(novaChance: float) -> void:
	if isChanceValida(novaChance):
		chanceDeSobrevivencia = novaChance
	else:
		notificarChanceInvalida()

# Atualiza a disponibilidade
func alternarDisponibilidade():
	isDisponivel = !isDisponivel
	$UI/BotaoVoltar.visible = !$UI/BotaoVoltar.visible
# Verifica se o funcionário tem medo para operar
func isMedoAlto() -> bool:
	return medo >= VALOR_MEDO_ALTO

func notificarMedoAlto() -> void:
	print(nome, "está com muito medo!")

func notificarMedoAceitavel() -> void:
	print(nome, "está com nível aceitável de medo para continuar operando.")

func checarMedo() -> bool:
	if isMedoAlto():
		notificarMedoAlto()
		return false
	else:
		notificarMedoAceitavel()
		return true
func _process(_delta):
	var offset = Vector2(-50, -100)
	$UI/BotaoVoltar.position = global_position + offset
	atualizar_barra_medo()

# ===== SISTEMA DE MEDO/FUGA =====

func criar_barra_medo():
	# Cria ProgressBar para mostrar nível de medo
	var barra = ProgressBar.new()
	barra.name = "BarraMedo"
	barra.min_value = 0
	barra.max_value = 1.0
	barra.value = 0
	barra.custom_minimum_size = Vector2(80, 8)
	barra.position = Vector2(-40, -80)
	barra.show_percentage = false
	
	# Estilo da barra
	var style = StyleBoxFlat.new()
	style.bg_color = Color.YELLOW
	barra.add_theme_stylebox_override("fill", style)
	
	$UI.add_child(barra)
	barra.visible = false  # Inicialmente invisível

func atualizar_barra_medo():
	if not has_node("UI/BarraMedo"):
		return
		
	var barra = $UI/BarraMedo
	barra.value = medo
	
	# Mostra barra apenas se houver medo
	barra.visible = medo > 0
	
	# Muda cor conforme nível de medo
	var style = StyleBoxFlat.new()
	if medo < 0.4:
		style.bg_color = Color.YELLOW
	elif medo < 0.7:
		style.bg_color = Color.ORANGE
	else:
		style.bg_color = Color.RED
	
	barra.add_theme_stylebox_override("fill", style)

func funcionario_foge():
	print(nome, " descobriu o esquema e fugiu!")
	mostrar_texto_fugiu()
	EventBus.FUNCIONARIO_FUGIU.emit(self)
	# A remoção da cena será feita pelo Jogador

func mostrar_texto_fugiu():
	var parent = get_parent()
	if not is_instance_valid(parent):
		return
	
	# Cria label flutuante com "FUGIU!"
	var label = Label.new()
	label.text = "FUGIU!"
	label.add_theme_font_size_override("font_size", 48)
	label.add_theme_color_override("font_color", Color.RED)
	label.position = global_position + Vector2(-50, -120)
	label.z_index = 100
	
	parent.add_child(label)
	
	# Cria tween no parent ao invés do funcionário
	var tween = parent.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 100, 2.0)
	tween.tween_property(label, "modulate:a", 0.0, 2.0)
	
	# Remove label após animação
	tween.finished.connect(func(): 
		if is_instance_valid(label):
			label.queue_free()
	)
