extends Panel

func _ready() -> void:
	$VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	get_parent()._on_back_to_menu()
