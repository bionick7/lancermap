extends Node2D

const TOKEN_TEMPLATE = preload("res://scenes/Token.tscn")

var queued_drops: Array[Texture2D] = []

@onready var socket: WebSocketClient = $Socket
@onready var map: HexMap = $HexMap
@onready var token_builder: TokenBuilder = $TokenBuilder

func _ready():
	socket.connected_to_server.connect(_on_connected)
	socket.connection_closed.connect(_on_disconnected)
	socket.token_data_received.connect(_on_token_data_received)
	socket.token_img_received.connect(_on_token_imgdata_received)
	socket.token_list_received.connect(_on_token_list_received)
	socket.token_kill_received.connect(_on_token_kill_received)
	
	Grid.on_config_changed.connect(_update_grid)
	get_viewport().files_dropped.connect(_on_files_dropped)
	token_builder.request_remove.connect(_remove_token.bind(true))
		
	if ProjectSettings.get("connections/in_testing"):
		socket.connect_to_url(ProjectSettings.get("connections/test_socket_url"))
	else:
		socket.connect_to_url(ProjectSettings.get("connections/socket_url"))
	#socket.connect_to_url("wss://lancermap.fly.dev")
	
	%ConnectionStatus.text = "Offline"

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		_handle_filedrops(get_global_mouse_position())

func _handle_filedrops(mouse_pos: Vector2) -> void:
	while len(queued_drops) > 0:
		var texture = queued_drops.pop_front()
		var token = _spawn_token((randi() << 32) + randi())
		
		token_builder.setup(token, texture)
		token_builder.set_map_parameters()
		
		await token_builder.setup_complete
				
		if not is_instance_valid(token) or token.is_queued_for_deletion():
			continue
		if not token_builder.is_confirmed:
			token.queue_free()
			NetworkingSingleton.tokens.erase(token.uuid)
			continue
			
		token.move_to(mouse_pos)
		if NetworkingSingleton.is_room_valid():
			token.is_online = true
			socket.send(WebSocketClient.RequestActionCode.SET_DATA, token.uuid, token.serialize())
			socket.send(WebSocketClient.RequestActionCode.SET_IMG, token.uuid, token.serialize_image())

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
	NetworkingSingleton.tokens[id] = res
	res.data_changed.connect(
		func(x): 
			if NetworkingSingleton.is_room_valid():
				socket.send(WebSocketClient.RequestActionCode.SET_DATA, x.uuid, x.serialize())
			if x.is_player:
				map.update_map_visibility()
	)
	res.request_edit.connect(
		func (x):
			if not x.can_manipulate():
				return
			token_builder.setup(x)
			token_builder.set_map_parameters()
	)
	#prints(vp.canvas_transform, vp.get_mouse_position(), get_global_mouse_position())
	return res
		
func _remove_token(token: Token, communicate: bool=true) -> void:
	if communicate and token.is_online:
		if not token.can_manipulate():
			return
		socket.send(WebSocketClient.RequestActionCode.KILL_TOKEN, token.uuid)
		# Request only
	else:
		token.queue_free()
		NetworkingSingleton.tokens.erase(token.uuid)
		
func _update_grid(from_remote: bool) -> void:
	if from_remote: return 
	socket.send(WebSocketClient.RequestActionCode.SET_DATA, 0, map.serialize())
	
func _update_map_image() -> void:
	socket.send(WebSocketClient.RequestActionCode.SET_IMG, 0)
	
func _on_token_data_received(token_id: int, data: Variant) -> void:
	print("%s Recieved data: token=%s, data=%s" % [NetworkingSingleton.self_name, token_id, data])
	if token_id == 0:
		map.deserialize(data)
		return
	var token: Token
	if token_id not in NetworkingSingleton.tokens:
		token = _spawn_token(token_id)
		token.is_spawned_by_local = false
		token.is_online = true
	else:
		token = NetworkingSingleton.tokens[token_id]
	token.deserialize(data)
	if token.is_player:
		map.update_map_visibility()
	
func _on_token_imgdata_received(token_id: int, data: PackedByteArray) -> void:
	print("%s Recieved imgdata: token=%s, data=byte x %s" % [NetworkingSingleton.self_name, token_id, len(data)])
	if token_id == 0:
		$HexMap/Map.download_map()
		return
	var token: Token
	if token_id not in NetworkingSingleton.tokens:
		token = _spawn_token(token_id)
		token.is_spawned_by_local = false
		token.is_online = true
	else:
		token = NetworkingSingleton.tokens[token_id]
	token.deserialize_image(data)

func _on_token_list_received(tokens: PackedInt64Array) -> void:
	print("%s Recieved: token list", NetworkingSingleton.self_name)
	for t in tokens:
		print("- ", t)
	# TODO: clean up tokens that are not in token list

func _on_token_kill_received(token_id: int) -> void:
	print("%s Recieved token kill %s" % [NetworkingSingleton.self_name, token_id])
	if token_id not in NetworkingSingleton.tokens:
		push_error("Tried to remove unexisting token %X" % token_id)
		return
	_remove_token(NetworkingSingleton.tokens[token_id], false)

func _on_files_dropped(files: PackedStringArray) -> void:
	if $ExpectingMap.visible:
		$ExpectingMap.hide()
		var map_file: String = files[0]
		files.remove_at(0)
		var img := Image.load_from_file(map_file)
		if is_instance_valid(img):
			$HexMap/Map.set_map(img)
		else:
			push_error("Could not open \"%s\"" % map_file)
			socket.send(WebSocketClient.RequestActionCode.SET_IMG, 0)
		_update_map_image()
	for fp in files:
		var img := Image.load_from_file(fp)
		var texture := ImageTexture.create_from_image(img)
		queued_drops.append(texture)
	get_window().grab_focus()

func _on_host_pressed():
	NetworkingSingleton.is_gm = true
	NetworkingSingleton.room = %RoomName.text
	socket.send(WebSocketClient.RequestActionCode.REG_AS_GM)
	_update_grid(false)
	_update_map_image()
	%ConnectionStatus.text = "Playing as Gm"
	
	for id in NetworkingSingleton.tokens:
		NetworkingSingleton.tokens[id].is_online = true
		socket.send(WebSocketClient.RequestActionCode.SET_DATA, id, NetworkingSingleton.tokens[id].serialize())
		socket.send(WebSocketClient.RequestActionCode.SET_IMG, id, NetworkingSingleton.tokens[id].serialize_image())
	
	var joined_successfull: bool = await socket.room_ready
	if joined_successfull:
		$HexMap/Map.set_map($HexMap/Map.texture.get_image())

func _on_join_pressed():
	NetworkingSingleton.is_gm = false
	NetworkingSingleton.room = %RoomName.text
	socket.send(WebSocketClient.RequestActionCode.REG_AS_PLAYER)
	%ConnectionStatus.text = "Playing as Player"
	var keys := NetworkingSingleton.tokens.keys()
	for id in keys:
		NetworkingSingleton.tokens[id].queue_free()
		NetworkingSingleton.tokens.erase(id)
		
	var joined_successfull: bool = await socket.room_ready

func _on_set_map_pressed():
	if not NetworkingSingleton.is_gm:
		return
	$ExpectingMap.popup_centered()
