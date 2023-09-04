extends Node2D

const TOKEN_TEMPLATE = preload("res://scenes/Token.tscn")

var room: String = "INVALID"
var tokens: Dictionary = {}

var queued_drops: Array[Texture2D] = []
var is_gm := true

@onready var self_name = "%d" % randi()
@onready var socket: WebSocketClient = $Socket
@onready var map: HexMap = $HexGrid
@onready var token_builder: TokenBuilder = $TokenBuilder

func _ready():
	socket.connected_to_server.connect(_on_connected)
	socket.connection_closed.connect(_on_disconnected)
	socket.token_data_received.connect(_on_token_data_received)
	socket.token_img_received.connect(_on_token_imgdata_received)
	socket.token_list_received.connect(_on_token_list_received)
	socket.token_kill_received.connect(_on_token_kill_received)
	
	map.grid_changed.connect(_update_grid)
	get_viewport().files_dropped.connect(_on_files_dropped)
	token_builder.request_remove.connect(_remove_token.bind(true))
		
	if ProjectSettings.get("connections/in_testing"):
		socket.connect_to_url(ProjectSettings.get("connections/test_socket_url"))
	else:
		socket.connect_to_url(ProjectSettings.get("connections/socket_url"))
	#socket.connect_to_url("wss://lancermap.fly.dev")
	
	%ConnectionStatus.text = "Offline"

func can_manipulate_token(token: Token) -> bool:
	return token.is_spawned_by_local or is_gm

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		_handle_filedrops(get_global_mouse_position())

func _handle_filedrops(mouse_pos: Vector2) -> void:
	while len(queued_drops) > 0:
		var texture = queued_drops.pop_front()
		var token = _spawn_token((randi() << 32) + randi())
		
		token_builder.setup(token, texture)
		token_builder.set_map_parameters(map)
		await token_builder.setup_complete
		if not is_instance_valid(token) or token.is_queued_for_deletion():
			continue
		if not token_builder.is_confirmed:
			token.queue_free()
			tokens.erase(token.uuid)
			continue
			
		token.move_to(mouse_pos)
		if room != "INVALID":
			token.is_online = true
			socket.send(room, WebSocketClient.RequestActionCode.SET_DATA, token.uuid, token.serialize())
			socket.send(room, WebSocketClient.RequestActionCode.SET_IMG, token.uuid, token.serialize_image())

#func _process(delta):
#	print(get_global_mouse_position())

func _on_connected() -> void:
	%ConnectionStatus.text = "Connected"
	
func _on_disconnected() -> void:
	%ConnectionStatus.text = "Offline"
	
func _spawn_token(id: int) -> Token:
	var res := TOKEN_TEMPLATE.instantiate()
	add_child(res)
	#var vp := get_viewport()
	res.uuid = id
	tokens[id] = res
	res.data_changed.connect(
		func(x): 
			if room == "INVALID":
				return
			socket.send(room, WebSocketClient.RequestActionCode.SET_DATA, x.uuid, x.serialize())
	)
	res.request_edit.connect(
		func (x):
			if not can_manipulate_token(x):
				return
			token_builder.setup(x)
			token_builder.set_map_parameters(map)
	)
	#prints(vp.canvas_transform, vp.get_mouse_position(), get_global_mouse_position())
	return res
		
func _remove_token(token: Token, communicate: bool=true):
	if communicate and token.is_online and room != "INVALID":
		if not can_manipulate_token(token):
			return
		socket.send(room, WebSocketClient.RequestActionCode.KILL_TOKEN, token.uuid)
		# Request only
	else:
		token.queue_free()
		tokens.erase(token.uuid)
		
func _update_grid():
	if room == "INVALID":
		return
	socket.send(room, WebSocketClient.RequestActionCode.SET_DATA, 0, map.serialize())
	
func _update_map_image():
	if room == "INVALID":
		return
	socket.send(room, WebSocketClient.RequestActionCode.SET_IMG, 0)
	
func _on_token_data_received(token_id: int, data: Variant) -> void:
	print("%s Recieved data: token=%s, data=%s" % [self_name, token_id, data])
	if token_id == 0:
		map.deserialize(data)
		return
	var token: Token
	if token_id not in tokens:
		token = _spawn_token(token_id)
		token.is_spawned_by_local = false
		token.is_online = true
	else:
		token = tokens[token_id]
	token.deserialize(data)
	
func _on_token_imgdata_received(token_id: int, data: PackedByteArray) -> void:
	print("%s Recieved imgdata: token=%s, data=byte x %s" % [self_name, token_id, len(data)])
	if token_id == 0:
		$HexGrid/Map.download_map(room)
		return
	var token: Token
	if token_id not in tokens:
		token = _spawn_token(token_id)
		token.is_spawned_by_local = false
		token.is_online = true
	else:
		token = tokens[token_id]
	token.deserialize_image(data)

func _on_token_list_received(tokens: PackedInt64Array) -> void:
	print("%s Recieved: token list", self_name)
	for t in tokens:
		print("- ", t)
	# TODO: clean up tokens that are not in token list

func _on_token_kill_received(token_id: int) -> void:
	print("%s Recieved token kill %s" % [self_name, token_id])
	_remove_token(tokens[token_id], false)

func _on_files_dropped(files: PackedStringArray) -> void:
	for fp in files:
		var img := Image.load_from_file(fp)
		var texture := ImageTexture.create_from_image(img)
		queued_drops.append(texture)
	get_window().grab_focus()

func _on_host_pressed():
	is_gm = true
	room = %RoomName.text
	socket.send(room, WebSocketClient.RequestActionCode.REG_AS_GM)
	_update_grid()
	_update_map_image()
	%ConnectionStatus.text = "Playing as Gm"
	
	for id in tokens:
		tokens[id].is_online = true
		socket.send(room, WebSocketClient.RequestActionCode.SET_DATA, id, tokens[id].serialize())
		socket.send(room, WebSocketClient.RequestActionCode.SET_IMG, id, tokens[id].serialize_image())
	
	var joined_successfull: bool = await socket.room_ready
	if joined_successfull:
		$HexGrid/Map.set_map(room, $HexGrid/Map.texture.get_image())

func _on_join_pressed():
	is_gm = false
	room = %RoomName.text
	socket.send(room, WebSocketClient.RequestActionCode.REG_AS_PLAYER)
	%ConnectionStatus.text = "Playing as Player"
	var keys := tokens.keys()
	for id in keys:
		tokens[id].queue_free()
		tokens.erase(id)
		
	var joined_successfull: bool = await socket.room_ready
	if joined_successfull:
		$HexGrid/Map.download_map(room)

func _on_set_map_pressed():
	if not is_gm:
		return
	$FileDialog.popup_centered()
	var file: String = await $FileDialog.file_selected
	var img := Image.load_from_file(file)
	if is_instance_valid(img):
		$HexGrid/Map.set_map(room, img)
	else:
		push_error("Could not open \"%s\"" % file)
		socket.send(room, WebSocketClient.RequestActionCode.SET_IMG, 0)
	_update_map_image()
