extends Node2D

@onready var jogadorRef: Jogador = $Jogador
@onready var jogadorGUIRef: JogadorGUI = $Jogador_GUI
@onready var timerRef = $Timer
@onready var lojaRef: Loja = $Jogador_GUI.get_node("Loja")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	EventBus.COMPRA_SOLICITADA.connect(jogadorRef.consultar_saldo_para_compra)
	EventBus.ITEM_SELECIONADO.connect(jogadorRef.instanciar_objetos)
	EventBus.COMPRA_REALIZADA.connect(lojaRef.remover_item_da_loja)
	EventBus.UPGRADE_ADQUIRIDO.connect(jogadorRef.adicionar_upgrade)
	_on_jogador_pronto()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_jogador_pronto() -> void:
	jogadorGUIRef = $Jogador_GUI
	jogadorGUIRef.timerGlobalRef = timerRef
	jogadorRef.definir_Nome("Maritaca")
	jogadorRef.alterar_dinheiro(+1000)
	jogadorRef.alterar_fama(0.2)
	jogadorGUIRef.atualizar_atributos()
	pass # Replace with function body.
