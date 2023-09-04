extends Camera2D

var dragging := false

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index in [MOUSE_BUTTON_RIGHT, MOUSE_BUTTON_MIDDLE]:
			if event.is_pressed():
				dragging = true
			else:
				dragging = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= 1.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= 0.9
	elif event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom
