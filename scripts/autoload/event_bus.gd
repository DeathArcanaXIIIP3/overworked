extends Node

#Sinais Funcionarios
@warning_ignore("unused_signal")
signal MEDO_MAXIMO_ATINGIDO
@warning_ignore("unused_signal")
signal PEDIR_RETORNO_PARA_INVENTARIO

#Sinais Jogador
@warning_ignore("unused_signal")
signal ATUALIZAR_ATRIBUTOS_GUI
@warning_ignore("unused_signal")
signal ATUALIZAR_INVENTARIOS_GUI
@warning_ignore("unused_signal")
signal COMPRA_REALIZADA
@warning_ignore("unused_signal")
signal JOGADOR_PRONTO
@warning_ignore("unused_signal")
signal CHECAR_COTA
@warning_ignore("unused_signal")
signal COTA_ALCANCADA
@warning_ignore("unused_signal")
signal ATUALIZAR_COTA_GUI
@warning_ignore("unused_signal")
signal FUNCIONARIO_ENTROU_NA_CENA

#Sinais Maquina
@warning_ignore("unused_signal")
signal FUNCIONARIO_COMEÇOU_A_OPERAR_MAQUINA
@warning_ignore("unused_signal")
signal FUNCIONARIO_MORREU_NA_MAQUINA
@warning_ignore("unused_signal")
signal FUNCIONARIO_PAROU_DE_OPERAR_MAQUINA

#Sinais GUI
@warning_ignore("unused_signal")
signal ITEM_SELECIONADO
@warning_ignore("unused_signal")
signal UPGRADE_ADQUIRIDO
@warning_ignore("unused_signal")
signal FIM_DO_MES
@warning_ignore("unused_signal")
signal FIM_DO_DIA

#Sinais Loja
@warning_ignore("unused_signal")
signal COMPRA_SOLICITADA
@warning_ignore("unused_signal")
signal ATUALIZAR_INVENTARIO

#Sinais Main
@warning_ignore("unused_signal")
signal CAMERA_PRONTA

#Sinais Quota
@warning_ignore("unused_signal")
signal NOVA_COTA

#Sinais GeradorDeFuncionarios
@warning_ignore("unused_signal")
signal NOVO_FUNCIONARIO_GERADO

#Sinais Sistema de Fama
@warning_ignore("unused_signal")
signal FAMA_CRITICA
@warning_ignore("unused_signal")
signal GAME_OVER
@warning_ignore("unused_signal")
signal FUNCIONARIO_FUGIU

#Sinais Sistema de Atenção
@warning_ignore("unused_signal")
signal ATENCAO_AUMENTADA
@warning_ignore("unused_signal")
signal TENTATIVA_MORTE_FALHOU
