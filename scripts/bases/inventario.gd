extends Control

var ativo = false
var tabContainerOriginalPosition: Vector2
var activeTabIndex = null

func _ready() -> void:
	tabContainerOriginalPosition = self.position
	pass

func expandir_inventario():
	print("TESTE")
	var tabContainerNewPosition = tabContainerOriginalPosition
	tabContainerNewPosition[1] -= 320
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"position",tabContainerNewPosition, 1.0)
	pass

func retrair_inventario():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self,"position",tabContainerOriginalPosition, 1.0)
	pass

func alternar_visibilidade():
	ativo = !ativo
	
func _on_tab_clicked(tab: int) -> void:
	if !ativo:
		alternar_visibilidade()
		expandir_inventario()
		activeTabIndex = tab
	elif tab == activeTabIndex:
		retrair_inventario()
		alternar_visibilidade()
	else: 
		activeTabIndex = tab
	pass # Replace with function body.
