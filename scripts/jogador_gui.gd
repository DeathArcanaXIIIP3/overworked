extends Control

func atualizar_GUI(dadosJogador: Jogador):
	$Dinheiro.text = "Dinheiro:  " + str(dadosJogador.dinheiro) 
	$Almas.text = "Almas:  " + str(dadosJogador.almas) 
	$Fama.text = "Fama: " + str(dadosJogador.fama)
	pass
