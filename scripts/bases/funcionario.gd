extends Node2D

class_name Funcionario

const LIMITE_MAX_MEDO = 1.0
const VALOR_MEDO_ALTO = LIMITE_MAX_MEDO - 0.2
const INCREMENTO_MEDO_PADRAO = 0.1

signal MEDO_MAXIMO_ATINGIDO

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

func setup(data:FuncionarioData):
	nome = data.nome
	preco = data.preco
	produtividade = data.produtividade
	
	taxaDeAcidente = data.taxa_de_acidente
	taxaDeMedo = data.taxa_de_medo
	
	isDisponivel = data.isDisponivel
	
	profilePicture = data.profilePicture
	$Sprite.texture = data.profilePicture

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
	if checarMedoMaximo():
		MEDO_MAXIMO_ATINGIDO.emit(self)
	print("Medo atualizado para: ", medo)

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
	match isDisponivel:
		true:
			isDisponivel = false
		false:
			isDisponivel = true

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
