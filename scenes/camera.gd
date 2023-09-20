class_name MovableCamera
extends Camera2D

var dragging := false

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			handle_rmb(event)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= 1.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= 0.9
	elif event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom

func handle_rmb(event: InputEventMouseButton) -> void:
	# RMB needs to be handled by ClickHandler
	if event.is_pressed():
		dragging = true
	else:
		dragging = false
