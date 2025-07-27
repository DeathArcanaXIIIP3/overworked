extends Button


func _ready():
	self.pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/main.tscn")
