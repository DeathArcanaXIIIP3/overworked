extends PanelContainer

const OFFSET_LEFT = -250.0

func _input(event: InputEvent) -> void:
	if self.visible and event is InputEventMouseMotion:
		var viewport = get_viewport_rect()
		var mousePos = get_global_mouse_position()
		if mousePos[0] > viewport.size[0] / 2:
			mousePos[0] += OFFSET_LEFT
			self.position = mousePos
		else:
			self.position = mousePos 
