extends Node2D

@export var hexgrid: HexMap
@export var camera: MovableCamera

var primary_token = null

var show_forbidden := false

func _process(dt: float):
	if show_forbidden:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_FORBIDDEN)
	else:
		DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		primary_token = null
		for token in _get_tokens():
			if token.is_mb_hovering():
				primary_token = token
				break
		show_forbidden = is_instance_valid(primary_token) and not primary_token.can_manipulate()
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_handle_lmb(event)
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_handle_rmb(event)
		
func _handle_lmb(event: InputEventMouseButton) -> void:
	if not event.pressed:
		for token in _get_tokens():
			token.dragging = false
	
	if hexgrid.active_measure_mode != HexMap.MeasuringMode.NONE:
		hexgrid.handle_mouse_button(event, primary_token)
		
	elif is_instance_valid(primary_token) and primary_token.can_manipulate() and event.pressed:
		primary_token.dragging = true

func _handle_rmb(event: InputEventMouseButton) -> void:
	if hexgrid.active_measure_mode == HexMap.MeasuringMode.FOG:
		hexgrid.handle_mouse_button(event, null)
		return
		
	if is_instance_valid(primary_token) and primary_token.can_manipulate() and event.pressed:
		primary_token.request_edit.emit(primary_token)
		return
	
	camera.handle_rmb(event)
			
func _get_tokens() -> Array:
	return NetworkingSingleton.tokens.values()
