extends PanelContainer

const OFFSET_LEFT = -250.0

func _input(event: InputEvent) -> void:
	if self.visible and event is InputEventMouseMotion:
		var mousePos = get_global_mouse_position()
		self.position = mousePos 
