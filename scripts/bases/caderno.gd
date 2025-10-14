extends Control

var ativo = false
var tabContainerOriginalPosition: Vector2
var activeTabIndex = null

func _ready() -> void:
	tabContainerOriginalPosition = $TabContainer.position

func expandir_inventario():
	print("TESTE")
	var tabContainerNewPosition = tabContainerOriginalPosition
	tabContainerNewPosition[1] -= 96
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($TabContainer,"position",tabContainerNewPosition, 1.5)
	pass

func retrair_inventario():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property($TabContainer,"position",tabContainerOriginalPosition, 1.5)
	pass

func alternar_visibilidade():
	ativo = !ativo

func _on_tab_container_tab_clicked(tab: int) -> void:
	print("Tab Atual: ", activeTabIndex)
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
