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
	
	# Controla visibilidade das sprites baseado na aba
	atualizar_sprites_inventario(tab)
	pass # Replace with function body.

func atualizar_sprites_inventario(tab_index: int) -> void:
	# Tab 0 = Funcionários, Tab 1 = Decorações
	var sprite_inventario1 = get_node_or_null("inventario1")
	var sprite_inventario2 = get_node_or_null("inventario2")
	
	if sprite_inventario1 == null or sprite_inventario2 == null:
		print("AVISO: Sprites de inventário não encontradas")
		print("inventario1: ", sprite_inventario1)
		print("inventario2: ", sprite_inventario2)
		return
	
	if tab_index == 0:  # Aba Funcionários
		sprite_inventario1.visible = false
		sprite_inventario2.visible = true
	elif tab_index == 1:  # Aba Decorações
		sprite_inventario1.visible = true
		sprite_inventario2.visible = false
