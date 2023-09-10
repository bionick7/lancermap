extends Node2D

@export var hexgrid: HexMap
@export var camera: MovableCamera

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_handle_lmb(event)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_handle_rmb(event)
		
func _handle_lmb(event: InputEventMouseButton) -> void:
	if not event.pressed:
		for token in _get_tokens():
			token.dragging = false
	
	var primary_token = null
	for token in _get_tokens():
		if event.pressed and token.is_mb_hovering():
			primary_token = token
			break
	
	if hexgrid.active_measure_mode != HexMap.MeasuringMode.NONE:
		hexgrid.handle_mouse_button(event, primary_token)
		
	elif primary_token != null:
		primary_token.dragging = true

func _handle_rmb(event: InputEventMouseButton) -> void:
	if hexgrid.active_measure_mode == HexMap.MeasuringMode.FOG:
		hexgrid.handle_mouse_button(event, null)
		return
		
	for token in _get_tokens():
		if event.pressed and token.is_mb_hovering():
			token.request_edit.emit(token)
			return
	
	camera.handle_rmb(event)
			
func _get_tokens() -> Array:
	return NetworkingSingleton.tokens.values()
