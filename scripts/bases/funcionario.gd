extends Node2D

class_name Funcionario

var Nome: String
var Taxa_de_sobrevivencia: float
var Medo: float
var Produtividade: float
var Preço_do_funcionario: int
var isDisponivel: bool
var Multiplicador_de_medo: float
var Medo_total: int
var Contrato: int
var Chance_de_sobrevivencia: float

# Getter para o nome
func get_nome() -> String:
	return Nome

# Setter para o nome
func set_nome(novo_nome: String) -> void:
	Nome = novo_nome
	print("Nome alterado para: ", novo_nome)

# Getter para a produtividade
func get_produtividade() -> float:
	return Produtividade

# Setter para a produtividade
func set_produtividade(nova_produtividade: float) -> void:
	if nova_produtividade >= 0:
		Produtividade = nova_produtividade
	else:
		print("A produtividade não pode ser negativa.")

# Atualiza a produtividade
func atualizar_produtividade(fator: float) -> void:
	Produtividade += fator
	if Produtividade < 0:
		Produtividade = 0
	print("Produtividade atualizada para: ", Produtividade)

# Atualiza o medo para mais 10%
func atualizar_medo() -> void:
	if Medo < 1.0:
		Medo += 0.1
		if Medo > 1.0:
			print("Medo máximo atingido\n")
			Medo = 1.0
	print("Medo atualizado para: ", Medo)

# Getter para a taxa de sobrevivência
func get_taxa_de_sobrevivencia() -> float:
	return Taxa_de_sobrevivencia

# Setter para a taxa de sobrevivência
func set_taxa_de_sobrevivencia(nova_taxa: float) -> void:
	if nova_taxa >= 0 and nova_taxa <= 1:
		Taxa_de_sobrevivencia = nova_taxa
	else:
		print("Taxa de sobrevivência inválida. Deve ser entre 0 e 1.")

# Getter para o preço do funcionário
func get_preco_do_funcionario() -> int:
	return Preço_do_funcionario

# Setter para o preço do funcionário
func set_preco_do_funcionario(novo_preco: int) -> void:
	if novo_preco >= 0:
		Preço_do_funcionario = novo_preco
	else:
		print("O preço do funcionário não pode ser negativo.")

# Getter para o multiplicador de medo
func get_multiplicador_de_medo() -> float:
	return Multiplicador_de_medo

# Setter para o multiplicador de medo
func set_multiplicador_de_medo(novo_multiplicador: float) -> void:
	if novo_multiplicador >= 0:
		Multiplicador_de_medo = novo_multiplicador
	else:
		print("O multiplicador de medo não pode ser negativo.")

# Getter para o medo total
func get_medo_total() -> int:
	return Medo_total

# Setter para o medo total
func set_medo_total(novo_medo_total: int) -> void:
	if novo_medo_total >= 0:
		Medo_total = novo_medo_total
	else:
		print("O medo total não pode ser negativo.")

# Getter para o contrato
func get_contrato() -> int:
	return Contrato

# Setter para o contrato
func set_contrato(novo_contrato: int) -> void:
	if novo_contrato >= 0:
		Contrato = novo_contrato
	else:
		print("O contrato não pode ser negativo.")

# Getter para a chance de sobrevivência
func get_chance_de_sobrevivencia() -> float:
	return Chance_de_sobrevivencia

# Setter para a chance de sobrevivência
func set_chance_de_sobrevivencia(nova_chance: float) -> void:
	if nova_chance >= 0 and nova_chance <= 1:
		Chance_de_sobrevivencia = nova_chance
	else:
		print("Chance de sobrevivência inválida. Deve ser entre 0 e 1.")

# Atualiza a disponibilidade
func atualizar_is_disponivel(disponivel: bool) -> void:
	isDisponivel = disponivel
	if isDisponivel:
		print(Nome, "está disponível para operar a máquina.")
	else:
		print(Nome, "não está disponível para operar a máquina.")

# Verifica se o funcionário tem medo para operar
func checar_medo() -> bool:
	if Medo >= 0.8:
		print(Nome, "está com muito medo!")
		return false
	else:
		print(Nome, "está com nível aceitável de medo para continuar operando.")
		return true
