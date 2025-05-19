# TabContainer.gd
extends TabContainer

# Simulando dados diferentes para cada aba
var items_por_aba = [
	["Espada", "Arco", "Martelo"],
	["Poção", "Elixir", "Bomba"],
	["Mapa", "Chave", "Lanterna"]
]

func _ready():
	for i in range(get_child_count()):
		var scroll = get_child(i)
		var vbox = scroll.get_child(0)
		vbox.clear()  # Limpa qualquer conteúdo anterior

		for nome_item in items_por_aba[i]:
			var botao = Button.new()
			botao.text = nome_item
			botao.pressed.connect(func(): _on_item_clicado(nome_item))
			vbox.add_child(botao)

func _on_item_clicado(nome_item):
	print("Você clicou no item:", nome_item)
