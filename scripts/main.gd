extends Node2D

@onready var jogadorRef
@onready var jogadorGUIRef
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_jogador_jogador_pronto(jogadorNode) -> void:
	jogadorRef = jogadorNode
	jogadorGUIRef = $Jogador_GUI
	jogadorGUIRef.jogadorRef = jogadorNode
	jogadorRef.definir_Nome("Maritaca")
	jogadorRef.alterar_dinheiro(+100)
	jogadorRef.alterar_fama(0.2)
	
	jogadorGUIRef.atualizar_GUI()
	pass # Replace with function body.
