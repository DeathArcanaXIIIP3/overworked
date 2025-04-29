extends Node2D

var João = {
	"Nome": "João Silva",
	"TaxaDeMorte": 0.5
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var maquinaImpressão = preload("res://cenas/maquina.tscn").instantiate()
	var maquinaImpressãoData = preload("res://resources/Maquina_De_Impressão.tres")
	
	maquinaImpressão.setup(maquinaImpressãoData)
	
	add_child(maquinaImpressão)
	
	maquinaImpressão.mostrarStatus()
	maquinaImpressão.adicionarFuncionario(João)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
