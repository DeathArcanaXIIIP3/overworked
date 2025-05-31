extends Node2D

class_name Funcionario

const MEDO_LIMITE_ALTO = 0.8
const MEDO_LIMITE_MAXIMO = 1.0
const INCREMENTO_MEDO_PADRAO = 0.1

var nome: String
var taxaDeSobrevivencia: float
var medo: float
var produtividade: float
var precoDoFuncionario: int
var multiplicadorDeMedo: float
var medoTotal: int
var contrato: int
var chanceDeSobrevivencia: float
var profilePicture: Texture

#--Booleanos pra validação de status--#
var isDisponivel: bool

func setup(data:FuncionarioData):
	nome = data.nome
	#taxaDeSobrevivencia = data.Taxa_de_sobrevivencia
	taxaDeSobrevivencia = data.taxaDeSobrevivencia
	medo = data.Medo
	produtividade = data.Produtividade
	precoDoFuncionario = data.precoDoFuncionario
	isDisponivel = data.isDisponivel
	#profilePicture = data.profilePicture
	$Sprite.texture = data.profilePicture
	randomizar_atributos()
	
# Getter para o nome
func randomizar_atributos() -> void:
	# Garante que o gerador está randomizado
	randomize()
	
	# Randomiza os atributos mantendo nome e sprite, com duas casas decimais
	taxaDeSobrevivencia = round(randf() * 100.0) / 100.0
	medo = round(randf() * 100.0) / 100.0
	produtividade = round(randf() * 10000.0) / 100.0  # para permitir 0–100 com duas casas
	isDisponivel = true  
	
	# Log para debug
	print("Funcionário randomizado:")
	print("Taxa de Sobrevivência:", taxaDeSobrevivencia)
	print("Medo:", medo)
	print("Produtividade:", produtividade)
	print("Preço:", precoDoFuncionario)
	print("Disponível:", isDisponivel)


func getNome() -> String:
	return nome

# Setter para o nome
func setNome(novoNome: String) -> void:
	nome = novoNome
	print("Nome alterado para: ", novoNome)

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
	return medo >= MEDO_LIMITE_MAXIMO
	
func notificarMedoMaximo() -> void:
	print("Medo máximo atingido\n")
	
func atualizarMedo() -> void:
	incrementarMedo(INCREMENTO_MEDO_PADRAO)
	if checarMedoMaximo():
		notificarMedoMaximo()
	print("Medo atualizado para: ", medo)

# Getter para a taxa de sobrevivência
func getTaxaDeSobrevivencia() -> float:
	return taxaDeSobrevivencia

# Setter para a taxa de sobrevivência
func isTaxaValida(valor: float) -> bool:
	return valor >= 0 and valor <= 1
	
func notificarTaxaInvalida() -> void:
	print("Taxa de sobrevivência inválida. Deve ser entre 0 e 1.")
	
func setTaxaDeSobrevivencia(novaTaxa: float) -> void:
	if isTaxaValida(novaTaxa):
		taxaDeSobrevivencia = novaTaxa
	else:
		notificarTaxaInvalida()

# Getter para o preço do funcionário
func getPrecoDoFuncionario() -> int:
	return precoDoFuncionario

# Setter para o preço do funcionário
func isPrecoValido(valor: int) -> bool:
	return valor >= 0
	
func notificarPrecoInvalido() -> void:
	print("O preço do funcionário não pode ser negativo.")
	
func setPrecoDoFuncionario(novoPreco: int) -> void:
	if isPrecoValido(novoPreco):
		precoDoFuncionario = novoPreco
	else:
		notificarPrecoInvalido()

# Getter para o multiplicador de medo
func getMultiplicadorDeMedo() -> float:
	return multiplicadorDeMedo

# Setter para o multiplicador de medo
func isMultiplicadorValido(valor: float) -> bool:
	return valor >= 0
	
func notificarMultiplicadorInvalido() -> void:
	print("O multiplicador de medo não pode ser negativo.")
	
func setMultiplicadorDeMedo(novoMultiplicador: float) -> void:
	if isMultiplicadorValido(novoMultiplicador):
		multiplicadorDeMedo = novoMultiplicador
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
	match isDisponivel:
		true:
			isDisponivel = false
		false:
			isDisponivel = true

# Verifica se o funcionário tem medo para operar
func isMedoAlto() -> bool:
	return medo >= MEDO_LIMITE_ALTO

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
