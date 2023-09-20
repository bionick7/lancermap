GDPC                                                                                       $   h   res://.godot/exported/133200997/export-2fea4c23ecd46349759679c08410c386-measure_mode_button_group.res   �
            Ń�d���\���Eއ    P   res://.godot/exported/133200997/export-4a24720ee5e787dbe30abc634fa3679d-Main.scn0�      	      ��%�E-0Խ��r�P    \   res://.godot/exported/133200997/export-6b436129bf1eaed15c30d7527c74f0ea-token_builder.scn   P�      �      �xx�.w�O�kr��    X   res://.godot/exported/133200997/export-7cf3fd67ad9f55210191d77b582b8209-default_env.res @�      �	      ��OJ�t����c�o��    T   res://.godot/exported/133200997/export-c8e30baf94148b25e4bac2b4fd4315c5-Token.scn   ��      �      q�y���7s��sT�K�    ,   res://.godot/global_script_class_cache.cfg          2      %�	�[y��+E]�|    D   res://.godot/imported/icon.png-487276ed1e3a0c39cad0279d744ee560.ctex �      	      �̷������~��9�N�    D   res://.godot/imported/outp.png-8087ac0d633aa39a3bacf30106466c8c.ctex�     RR      �;�,����m&Ȉ���       res://.godot/uid_cache.bin  pn     �       _rޖ���j��`=���'    4   res://addons/coi_serviceworker/coi_export_plugin.gd @      �      ����t�V�c�q�
��    ,   res://addons/coi_serviceworker/coi_plugin.gd 	      a      k`f�w�OvPN����<%       res://default_env.tres.remap�`     h       cXv�S��P�O�Tq�o       res://icon.png  �`     v      ge��@o�7�|AZ       res://icon.png.import   @�      �       �6C�B��i,���W�       res://map.gdshader  �      p      R��
<$`ho~Ǳ|P�    0   res://misc/measure_mode_button_group.tres.remap �^     v       tUn+NZw @�Dc��3�       res://outp.png.import   �]     �       ��JN��.�/[�l�Z�       res://project.binarypo     �      M��G4��)�C��P�       res://scenes/ClickHandler.gd�T      )      4������#ĉ��       res://scenes/Main.tscn.remap0_     a       �U���m$��H��       res://scenes/MapMask.gd ��      b      �]+ʄ!o��?VUF        res://scenes/Token.tscn.remap   �_     b       *�%�-��<K�X�!�       res://scenes/camera.gd   R      [      �ss��N�h[H9���       res://scenes/grid.gd�Z      �      ��*��|����8v��       res://scenes/hex_grid.gd`z      �      �M�&��B_���       res://scenes/map.gd @�      8      s�NL�.�i���9m    ,   res://scenes/networking/WebSocketClient.gd  `1      �      ���o�B��p��Du��    0   res://scenes/networking/connection_manager.gd   �      3      �����<|��v�\�    0   res://scenes/networking/http_image_handler.gd   �%      �	      4��.�f3��L�ދ�-    0   res://scenes/networking/networking_singleton.gd �/      �      dQU��N�t�A�����    4   res://scenes/networking/websocket_image_handler.gd  PE      �       &��G4;ގ,Ǵ�5�    ,   res://scenes/networking/wss_image_handler.gd@F      �      ��I5c�U�ǟՒRI       res://scenes/token.gd   �      �
      �Y}Ыt��1�&�X�w        res://scenes/token_builder.gd   ��      �	      *`d������U��+9    (   res://scenes/token_builder.tscn.remap   `     j       �I�"|�4��$�#    $   res://scenes/transform_preview.gd   0�      	      [5G�O6���YT:	EF    list=Array[Dictionary]([{
"base": &"Node2D",
"class": &"HexMap",
"icon": "",
"language": &"GDScript",
"path": "res://scenes/hex_grid.gd"
}, {
"base": &"HTTPRequest",
"class": &"HttpImageHandler",
"icon": "",
"language": &"GDScript",
"path": "res://scenes/networking/http_image_handler.gd"
}, {
"base": &"Sprite2D",
"class": &"MapSprite",
"icon": "",
"language": &"GDScript",
"path": "res://scenes/map.gd"
}, {
"base": &"Camera2D",
"class": &"MovableCamera",
"icon": "",
"language": &"GDScript",
"path": "res://scenes/camera.gd"
}, {
"base": &"Node2D",
"class": &"Token",
"icon": "",
"language": &"GDScript",
"path": "res://scenes/token.gd"
}, {
"base": &"AcceptDialog",
"class": &"TokenBuilder",
"icon": "",
"language": &"GDScript",
"path": "res://scenes/token_builder.gd"
}, {
"base": &"Control",
"class": &"TransformPreview",
"icon": "",
"language": &"GDScript",
"path": "res://scenes/transform_preview.gd"
}, {
"base": &"Node",
"class": &"WSSImageHandler",
"icon": "",
"language": &"GDScript",
"path": "res://scenes/networking/wss_image_handler.gd"
}, {
"base": &"Node",
"class": &"WebSocketClient",
"icon": "",
"language": &"GDScript",
"path": "res://scenes/networking/WebSocketClient.gd"
}, {
"base": &"Node",
"class": &"WebSocketServer",
"icon": "",
"language": &"GDScript",
"path": "res://websocket/WebSocketServer.gd"
}])
x��ܩH� Ĥ��[@tool
extends EditorExportPlugin

const JS_FILE = "coi-serviceworker.min.js"

var plugin_path: String = get_script().resource_path.get_base_dir()
var exporting_web := false
var export_path := ""

func _get_name() -> String:
	return "CoiServiceWorker"

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	if features.has("web"):
		exporting_web = true
		export_path = path
	
func _export_end() -> void:
	if exporting_web:
		var html := FileAccess.get_file_as_string(export_path)
		var pos = html.find('<script src=')
		html = html.insert(pos, '<script src="' + JS_FILE + '"></script>')
		var file := FileAccess.open(export_path, FileAccess.WRITE)
		file.store_string(html)
		file.close()
		DirAccess.copy_absolute(plugin_path.path_join(JS_FILE), export_path.get_base_dir().path_join(JS_FILE))
	exporting_web = false

func _export_file(path: String, type: String, features: PackedStringArray) -> void:
	if path.begins_with(plugin_path):
		skip()
@tool
extends EditorPlugin

var export_plugin: EditorExportPlugin = null

func _enter_tree() -> void:
	var path: String = get_script().resource_path
	export_plugin = load(path.get_base_dir().path_join("coi_export_plugin.gd")).new()
	add_export_plugin(export_plugin)

func _exit_tree() -> void:
	remove_export_plugin(export_plugin)
	export_plugin = null
{a��j�&yu�_RSRC                     ButtonGroup            ��������                                                  resource_local_to_scene    resource_name    script           local://ButtonGroup_qcsrl �          ButtonGroup             MeasureModeButtons       RSRC4<+����v�h��extends Node2D

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
~%��-I}���&class_name HttpImageHandler
extends HTTPRequest


var custom_headers := PackedStringArray([
	#"Access-Control-Allow-Origin: https://lancermap.fly.dev",
])

var is_requesting := false

signal image_received(img: Image)


func upload_img(url: String, image: Image) -> void:
	if is_requesting:
		await request_completed
	var error := request_raw(url, custom_headers, HTTPClient.METHOD_POST, image.save_png_to_buffer())
	if error != OK:
		push_error("Error occured tyinging to upload map at %s: %s" % [url, error_string(error)])
		return
	is_requesting = true
	var res : Array = await request_completed
	is_requesting = false
	var result: int = res[0]
	var return_code: int = res[1]
	var headers: PackedStringArray = res[2]
	var content: PackedByteArray = res[3]
	if result != OK:
		push_error("Error occured when uploading map at %s: %s" % [url, error_string(result)])
		return
	if return_code < 200 or return_code >= 300:
		var error_msg := "HTML returned with %d" % return_code
		for header in headers:
			if header.begins_with("Content-Type: text/plain; charset="):
				if header.substr(34) == "utf-8":
					error_msg += " :: " +content.get_string_from_utf8()
				else:
					error_msg += " :: " +content.get_string_from_ascii()
		push_error(error_msg)
		return
	print("Upload to %s successful" % url)

func download_img(url: String) -> void:
	if is_requesting:
		await request_completed
	var error := request_raw(url, custom_headers, HTTPClient.METHOD_GET)
	if error != OK:
		push_error("Error occured when downloading map at %s: %s" % [url, error_string(error)])
	is_requesting = true
	var res : Array = await request_completed
	is_requesting = false
	var result: int = res[0]
	var return_code: int = res[1]
	var headers: PackedStringArray = res[2]
	var content: PackedByteArray = res[3]
	if result != OK:
		push_error("Error occured when downloading map %s: %s" % [url, error_string(result)])
		return
	if return_code < 200 or return_code >= 300:
		var error_msg := "HTML returned with %d at %s" % [return_code, url]
		for header in headers:
			if header.begins_with("Content-Type: text/plain; charset="):
				if header.substr(34) == "utf-8":
					error_msg += " :: " +content.get_string_from_utf8()
				else:
					error_msg += " :: " +content.get_string_from_ascii()
		push_error(error_msg)
		return
	var image := Image.new()
	error = image.load_png_from_buffer(content)
	if error != OK:
		push_error("Error occured when downloading map at %s : %s" % [url, error_string(error)])
		return
	image_received.emit(image)
b8w|�� J#class_name NetworkingSingleton
extends Node


var room: String = "INVALID"
var tokens: Dictionary = {}
var is_gm := true

var active_socket = null

@onready var self_name = "%d" % randi()

func is_room_valid() -> bool:
	if room == "INVALID":
		return false
	return true

func get_player_tokens() -> Array:
	var res = []
	for t in tokens.values():
		if t.is_player:
			res.append(t)
	return res
���aextends Node
class_name WebSocketClient

enum RequestActionCode {
	INVALID = 0,
	
	GET_DATA = 1,
	SET_DATA = 2,
	GET_IMG = 3,
	SET_IMG = 4,
	
	REG_AS_GM = 5,
	REG_AS_PLAYER = 6,
	
	GET_TOKENS = 7,
	KILL_TOKEN = 8,
	
	IMAGE_HANDLING_START = 64,
	IMAGE_HANDLING_PACKET = 65,
	IMAGE_HANDLING_END = 66,
	IMAGE_REQUEST = 67,
}

enum ResponseActionCode {
	INVALID = 0,
	SEND_ERROR = 1,  # followed by string in utf-8
	SEND_DATA = 2,  # followed by token, then 0 or 1 for data or img, then bytes
	SEND_TOKEN_LIST = 3,  # followed by array of tokens (little-endian u64)
	SEND_TOKEN_KILL = 4,  # followed by token id
	SEND_REG_RESPONSE = 5,  # followed by single byte representing boolean (0 or 1) to confirm REG_AS_GM or REG_AS_PLAYER
	
	IMAGE_HANDLING_START = 64,
	IMAGE_HANDLING_PACKET = 65,
	IMAGE_HANDLING_END = 66,
}

@export var handshake_headers: PackedStringArray
@export var supported_protocols: PackedStringArray
var tls_options: TLSOptions = null

var socket = WebSocketPeer.new()
var last_state = WebSocketPeer.STATE_CLOSED

signal connected_to_server()
signal connection_closed()
signal token_data_received(token: int, data: Variant)
signal token_img_received(token: int, data: PackedByteArray)
signal token_list_received(tokens: PackedInt64Array)
signal token_kill_received(token: int)
signal room_ready(success: bool)
signal handle_image(action: ResponseActionCode, data: PackedByteArray)

func _ready():
	NetworkingSingleton.active_socket = self

func _process(dt: float):
	poll()

func _exit_tree():
	close(1001, "Application closed")

func connect_to_url(url) -> int:
	socket.supported_protocols = supported_protocols
	socket.handshake_headers = handshake_headers
	var err = socket.connect_to_url(url, tls_options)
	if err != OK:
		return err
	last_state = socket.get_ready_state()
	return OK

func send(action: RequestActionCode, token_id: int=1, payload: Variant={}) -> Error:
	if not NetworkingSingleton.is_room_valid() and action != RequestActionCode.IMAGE_REQUEST:
		#push_error("Called send without opening or joining a room")
		return FAILED
	if socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		return FAILED
	var buffer := _encode_msg(NetworkingSingleton.room, action, token_id, payload)
	return socket.send(buffer)
	
func send_raw(payload: PackedByteArray) -> Error:
	if socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		return FAILED
	return socket.send(payload)
	
func handle_message() -> void:
	if socket.get_available_packet_count() < 1:
		return
	var pkt := socket.get_packet()
	if socket.was_string_packet():
		var str = pkt.get_string_from_utf8()
		# TODO: handle string messages here, if applicable
		return 
	var response_code: ResponseActionCode = pkt.decode_u8(0)
	match response_code:
		ResponseActionCode.SEND_ERROR:
			var message := pkt.slice(1).get_string_from_utf8()
			JavaScriptBridge.eval("alert(\"" + message.json_escape() + "\");")
			push_error(message)
		ResponseActionCode.SEND_DATA:
			if pkt.decode_u8(9) == 1:
				token_img_received.emit(
					pkt.decode_u64(1),
					pkt.slice(10)
				)
			else:
				token_data_received.emit(
					pkt.decode_u64(1),
					bytes_to_var(pkt.slice(10))
				)
		ResponseActionCode.SEND_TOKEN_LIST:
			var token_num := (pkt.size() - 1) / 8
			var tokens = PackedInt64Array()
			tokens.resize(token_num)
			for i in range(token_num):
				tokens[i] = pkt.decode_u64(i * 8 + 1)
			token_list_received.emit(tokens)
		ResponseActionCode.SEND_TOKEN_KILL:
			token_kill_received.emit(pkt.decode_u64(1))
		ResponseActionCode.SEND_REG_RESPONSE:
			room_ready.emit(pkt.decode_u8(1) != 0)
		var other:
			if other in [ResponseActionCode.IMAGE_HANDLING_START, ResponseActionCode.IMAGE_HANDLING_PACKET, ResponseActionCode.IMAGE_HANDLING_END]:
				handle_image.emit(other, pkt.slice(1))
			else:
				push_error("Recieved invalid message code: %s" % other)

func close(code := 1000, reason := "") -> void:
	socket.close(code, reason)
	last_state = socket.get_ready_state()

func clear() -> void:
	socket = WebSocketPeer.new()
	last_state = socket.get_ready_state()

func get_socket() -> WebSocketPeer:
	return socket

func poll() -> void:
	if socket.get_ready_state() != socket.STATE_CLOSED:
		socket.poll()
	var state = socket.get_ready_state()
	if last_state != state:
		last_state = state
		if state == socket.STATE_OPEN:
			connected_to_server.emit()
		elif state == socket.STATE_CLOSED:
			connection_closed.emit()
	while socket.get_ready_state() == socket.STATE_OPEN and socket.get_available_packet_count():
		handle_message()

func _encode_msg(roomname: String, action: RequestActionCode, token_id: int, payload: Variant) -> PackedByteArray:
	var roomname_buffer := roomname.strip_escapes().to_utf8_buffer()
	var payload_buffer: PackedByteArray
	if payload is PackedByteArray:
		payload_buffer = payload
	else:
		payload_buffer = var_to_bytes(payload)
	var buffer := PackedByteArray()
	buffer.append(action)
	buffer.append_array(roomname_buffer)
	var pos := roomname_buffer.size() + 1
	buffer.resize(pos + 9)
	buffer.encode_u8(pos, 0)
	buffer.encode_u64(pos+1, token_id)
	buffer.append_array(payload_buffer)
	return buffer
extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
I�fclass_name WSSImageHandler
extends Node

const PACKET_SIZE = 50_000

signal image_received(img: Image)

var image_uuid: int

func upload_img(name: String, image: Image) -> void:
	# TODO: check if socket is valid
	image_uuid = (randi() << 32) + randi()
	var image_data := image.save_png_to_buffer()
	print(image_uuid)
	assert(len(image_data) < 4*1024*1024, "Image to large (capped at 32MB)")
	_start_image_transfer(image_data)
	for i in range(ceili(len(image_data) / float(PACKET_SIZE))):
		var start := i * PACKET_SIZE
		var end := mini((i+1) * PACKET_SIZE, len(image_data))
		_image_transfer_frame(image_data, start, end)
	_end_image_transfer(name)

func download_img(name: String) -> void:
	# TODO: check if socket is valid
	NetworkingSingleton.active_socket.send_raw(NetworkingSingleton.active_socket._encode_msg(
		name, WebSocketClient.RequestActionCode.IMAGE_REQUEST, 0, PackedByteArray()
	))
	var image_data := PackedByteArray()
	
	var uuid: int = -1
	# Should check for timeout or smth
	while true:
		var res: Array = await NetworkingSingleton.active_socket.handle_image
		var action: WebSocketClient.ResponseActionCode = res[0]
		var data: PackedByteArray = res[1]
		
		match action:
			WebSocketClient.ResponseActionCode.IMAGE_HANDLING_START:
				uuid = data.decode_u64(0)
				print("Init: ", uuid)
				print("Expected size: ", data.decode_u32(8))
			WebSocketClient.ResponseActionCode.IMAGE_HANDLING_PACKET:
				if uuid == data.decode_u64(0):
					var from = data.decode_u32(8)
					var to = data.decode_u32(12)
					print("(%s) from %d to %s (%d B)" % [uuid, from, to, len(data.slice(16))])
					image_data.append_array(data.slice(16))
			WebSocketClient.ResponseActionCode.IMAGE_HANDLING_END:
				if uuid == data.decode_u64(0):
					print("Done")
					break
	
	var image := Image.new()
	image.load_png_from_buffer(image_data)
	image_received.emit(image)

func _handle_image(response: WebSocketClient.ResponseActionCode, data: PackedByteArray) -> void:
	print(response)

func _start_image_transfer(image: PackedByteArray) -> void:
	var payload := PackedByteArray()
	payload.resize(1+8+4)
	payload.encode_u8(0, WebSocketClient.RequestActionCode.IMAGE_HANDLING_START)
	payload.encode_u64(1, image_uuid)
	payload.encode_u32(1+8, len(image))
	NetworkingSingleton.active_socket.send_raw(payload)
	
func _image_transfer_frame(image: PackedByteArray, from: int, to: int) -> void:
	var payload := PackedByteArray()
	payload.resize(1+8+4+4)
	payload.encode_u8(0, WebSocketClient.RequestActionCode.IMAGE_HANDLING_PACKET)
	payload.encode_u64(1, image_uuid)
	payload.encode_u32(1+8, from)
	payload.encode_u32(1+8+4, to)
	payload.append_array(image.slice(from, to))
	NetworkingSingleton.active_socket.send_raw(payload)
	
func _end_image_transfer(name: String) -> void:
	var payload := PackedByteArray()
	payload.resize(1+8)
	payload.encode_u8(0, WebSocketClient.RequestActionCode.IMAGE_HANDLING_END)
	payload.encode_u64(1, image_uuid)
	payload.append_array(name.to_utf8_buffer())
	NetworkingSingleton.active_socket.send_raw(payload)
�)�6�9~class_name MovableCamera
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
����extends Node2D

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
Qu\_���extends Node

enum Size {
	S1 = 1,
	S2 = 2,
	S3 = 3,
	S4 = 4,
}

enum FOWEffect {
	ShowAll,
	HideTokens,
	HideAll,
	NoSensors,
}

var blocking_tiles: Array = []
var visible_tiles: Array = []

var NEIGHBOUR_LOOKUP := PackedInt32Array([
	0,-1,  1,-1,  1,0,  0,1, -1,0, -1,-1,   # from % 2 (0, 0)  not horizontal
	0,-1,  1,-1,  1,0,  0,1, -1,0, -1,-1,   # from % 2 (0, 1)  not horizontal
	0,-1,  1, 0,  1,1,  0,1, -1,1, -1, 0,   # from % 2 (1, 0)  not horizontal
	0,-1,  1, 0,  1,1,  0,1, -1,1, -1, 0,   # from % 2 (1, 1)  not horizontal
	0,-1,  1, 0,  0,1, -1,1, -1,0, -1,-1,   # from % 2 (0, 0)      horizontal
	1,-1,  1, 0,  1,1,  0,1, -1,0,  0,-1,   # from % 2 (0, 1)      horizontal
	0,-1,  1, 0,  0,1, -1,1, -1,0, -1,-1,   # from % 2 (1, 0)      horizontal
	1,-1,  1, 0,  1,1,  0,1, -1,0,  0,-1,   # from % 2 (1, 1)      horizontal
])

var offset := Vector2.ZERO
var tile_size := Vector2(64, 64)
var is_horizontal := false
var fow_effect := FOWEffect.ShowAll

signal on_config_changed(from_remote: bool)

func _get_tile_estimate(inp: Vector2) -> Vector2i:
	var dx = (inp - offset).x / tile_size.x
	var dy = (inp - offset).y / tile_size.y
	if is_horizontal:
		var tmp = dx
		dx = dy
		dy = tmp
	dx += 0.25 * sign(dx)
	dy += 0.5 * sign(dy)
	var x0: int = dx * 1.3333
	var y0: int = dy if posmod(x0, 2) == 0 else dy - 0.5
	if is_horizontal:
		var tmp = x0
		x0 = y0
		y0 = tmp
	return Vector2i(x0, y0)

func get_tile(inp: Vector2) -> Vector2i:
	var p0 := _get_tile_estimate(inp)
	var min_dist_sqr = (eval_tile(p0) - inp).length_squared()
	#for c in [p0 + Vector2i(0, 1), p0 + Vector2i(1, 0), p0 + Vector2i(1, 1)]:
	for c in range(6).map(func(x): return get_neighbour(p0, x)):
		var dist_sqr = (eval_tile(c) - inp).length_squared()
		if dist_sqr < min_dist_sqr:
			p0 = c
			min_dist_sqr = dist_sqr
	return p0
	
func eval_tile(inp: Vector2i) -> Vector2:
	if is_horizontal:
		return Vector2(
			(inp.x + 0.5 if posmod(inp.y, 2) == 1 else inp.x) * tile_size.x + offset.x,
			inp.y * .75 * tile_size.y + offset.y,
		)
	else:
		return Vector2(
			inp.x * .75 * tile_size.x + offset.x,
			(inp.y + 0.5 if posmod(inp.x, 2) == 1 else inp.y) * tile_size.y + offset.y,
		)

func get_neighbour(from: Vector2i, neighbour_idx: int) -> Vector2i:
	var index = neighbour_idx + posmod(from.y, 2)*6 + posmod(from.x, 2)*12 + int(is_horizontal)*24
	return from + Vector2i(NEIGHBOUR_LOOKUP[index*2], NEIGHBOUR_LOOKUP[index*2 + 1])

func get_covered_tiles(center: Vector2i, size: Size) -> Array[Vector2i]:
	var res: Array[Vector2i] = [center]
	if size in [2, 4]:
		if is_horizontal:
			res.append(get_neighbour(center, 1))
			res.append(get_neighbour(center, 2))
		else:
			res.append(get_neighbour(center, 2))
			res.append(get_neighbour(center, 3))
	if size in [3, 4]:
		for t in res.duplicate():
			for i in range(6):
				var neighbour := get_neighbour(t, i)
				if neighbour not in res:
					res.append(neighbour)
	return res

func _floodfill(cache: Dictionary, in_domain: Callable, eval: Callable, end: Vector2i=Vector2i(1e10, 0)) -> Dictionary:
	var q :Array = cache.keys()
	while len(q) > 0:
		var current: Vector2i = q.pop_front()
		if current == end:
			return cache
		for i in range(6):
			var neighbour := get_neighbour(current, i)
			if in_domain.call(current, neighbour, cache[current]) and neighbour not in cache:
				cache[neighbour] = eval.call(current, neighbour, cache[current])
				q.append(neighbour)
	return cache
"""
func _get_closest(candidates: Array[Vector2i], to: Vector2i) -> Vector2i:
	var dest_pos := eval_tile(to)
	var best := candidates[0]
	var best_dist_sqr := eval_tile(candidates[0]).distance_squared_to(dest_pos)
	for candidate in candidates.slice(1):
		var dist_sqr := eval_tile(candidate).distance_squared_to(dest_pos)
		if dist_sqr < best_dist_sqr:
			best = candidate
			best_dist_sqr = dist_sqr
	assert(best in candidates)
	return best

func get_line(from: Vector2i, size: Size, to: Vector2i) -> Array[Vector2i]:
	var res : Array[Vector2i] = []
	var current = _get_closest(get_covered_tiles(from, size), to)
	while current != to:
		var neighbours : Array[Vector2i] = []
		for i in range(6): neighbours.append(get_neighbour(current, i))
		current = _get_closest(neighbours, to)
		res.append(current)
	return res
"""

func _does_tile_intersect_line(line_a: Vector2, line_b: Vector2, tile: Vector2i) -> bool:
	var tile_pos := eval_tile(tile)
	#if tile_pos.x < min(line_a.x, line_b.x) or tile_pos.x > max(line_a.x, line_b.x):
	#	return false
	#if tile_pos.y < min(line_a.y, line_b.y) or tile_pos.y > max(line_a.y, line_b.y):
	#	return false
	var ba := line_b - line_a
	var pa := tile_pos - line_a
	var h := clampf(pa.dot(ba) / ba.dot(ba), 0., 1.)
	var sdf := (pa - h * ba).length()
	return sdf < tile_size[tile_size.max_axis_index()] * .4

func has_line_of_sight(from: Vector2i, to: Vector2i) -> bool:
	if is_tile_occupied(to):
		return false
	var line_a := eval_tile(from)
	var line_b := eval_tile(to)
	for tile in blocking_tiles:
		if _does_tile_intersect_line(line_a, line_b, tile):
			return false
	
	return true

func get_line(from: Vector2i, size: Size, to: Vector2i) -> Array[Vector2i]:
	push_error("Cone tool not implemented")
	return []
	
func get_cone(from: Vector2i, size: Size, to: Vector2i) -> Array[Vector2i]:
	push_error("Cone tool not implemented")
	return []

func get_distance(from: Vector2i, size: Size, to: Vector2i) -> int:
	var bounds := Rect2i(
		mini(from.x, to.x),
		mini(from.y, to.y),
		absi(from.x - to.x)+1,
		absi(from.y - to.y)+1,
	)
	
	var cache = {}
	for p in get_covered_tiles(from, size):
		cache[p] = 0
	
	_floodfill(cache,
		func(parent, child, parent_cache): return bounds.has_point(child),
		func(parent, child, parent_cache): return parent_cache + 1,
	)
	return cache[to]
	
func _fill_distance_cache(bounds: Rect2i, current: Vector2i, cache: Dictionary) -> void:
	var neighbours = range(6).map(
		func(x): return get_neighbour(current, x)
	).filter(
		func(x): return bounds.has_point(x) and x not in cache
	)
	for neighbour in neighbours:
		cache[neighbour] = cache[current] + 1
	for neighbour in neighbours:
		_fill_distance_cache(bounds, neighbour, cache)


func get_shortest_path(from: Vector2i, size: Size, to: Vector2i) -> Array[Vector2i]:
	#var t0 = Time.get_ticks_usec()
	
	var bounds := Rect2i(
		mini(from.x, to.x),
		mini(from.y, to.y),
		absi(from.x - to.x)+1,
		absi(from.y - to.y)+1,
	)
	
	var cache = {}
	for p in get_covered_tiles(from, size):
		cache[p] = null
		
	_floodfill(cache,
		func(parent, child, parent_cache): return bounds.has_point(child),
#		func(parent, child, parent_cache): return not is_tile_occupied(child),
		func(parent, child, parent_cache): return parent,
	)
	
	if to not in cache:
		push_error("Should not reach")
		return []
	
	var res: Array[Vector2i] = []
	var backtrace = to
	while backtrace != null:
		res.append(backtrace)
		backtrace = cache[backtrace]
		
	return res

func is_tile_occupied(tile: Vector2i) -> bool:
	return tile in blocking_tiles

func get_burst(origin: Vector2i, size: Size, destination: Vector2i) -> Array:
	var distance = get_distance(origin, size, destination)
	return get_sensors(origin, size, distance, true)

func get_sensors(origin: Vector2i, size: Size, sensors: int, ignore_los: bool=false) -> Array:
	var cache := {}
	var origin_tiles := get_covered_tiles(origin, size)
	for p in get_covered_tiles(origin, size):
		cache[p] = sensors
		
	_floodfill(cache,
		func(parent, child, parent_cache): 
			if not ignore_los and not origin_tiles.any(func(x): return has_line_of_sight(x, child)):
				return false
			return parent_cache > 0, # TODO: abstacles
		func(parent, child, parent_cache): return parent_cache - 1,
	)
	
	return cache.keys()

func update_visible_tiles() -> void:
	visible_tiles.clear()
	if fow_effect == FOWEffect.NoSensors:
		return
	for p in NetworkingSingleton.get_player_tokens():
		for tile in get_sensors(p.tile, p.size, p.sensor_range):
			if tile not in visible_tiles:
				visible_tiles.append(tile)

func is_in_line_of_sight(tile: Vector2i, size: Size) -> bool:
	for s in get_covered_tiles(tile, size):
		if s in visible_tiles:
			return true
	return false
KOaeclass_name HexMap
extends Node2D

enum MeasuringMode {
	NONE,
	DISTANCE,
	LINE,
	CONE,
	BURST,
	FOG,
}

var UNITY_HEXAGON_VERT := PackedVector2Array([
	Vector2(.25, 0),
	Vector2(.75, 0),
	Vector2(1, .5),
	Vector2(.75, 1),
	Vector2(.25, 1),
	Vector2(0, .5),
	Vector2(.25, 0),
])

var UNITY_HEXAGON_HORI := PackedVector2Array([
	Vector2(0, .25),
	Vector2(0, .75),
	Vector2(.5, 1),
	Vector2(1, .75),
	Vector2(1, .25),
	Vector2(.5, 0),
	Vector2(0, .25),
])

@export var measure_mode_button_group: ButtonGroup

var active_measure_mode: MeasuringMode
var from_pos = null
var measure_size := 1 # temporary
var draw_alignment_help := false

@onready var default_font = Control.new().get_theme_default_font()
@onready var map_shadermat: ShaderMaterial = $Map.material

signal grid_changed()

func _ready():
	measure_mode_button_group.pressed.connect(_on_mm_button_pressed)
	_on_fog_item_selected(%Fog.selected)
	_on_grid_changed()
	_on_visible_tiles_changed()

func _input(event: InputEvent):
	if event is InputEventMouseMotion and active_measure_mode != MeasuringMode.NONE:
		_fog_draw_routine()
		queue_redraw()
	
	if event.is_action_pressed("show_grid_help"):
		draw_alignment_help = not draw_alignment_help
		queue_redraw()

func _draw():
	# Draws centering cross
	if draw_alignment_help:
		_draw_tile(Vector2i.ZERO)
		for direction in range(6):
			var running := Grid.get_neighbour(Vector2i.ZERO, direction)
			for dist in range(20):
				draw_string(default_font, Grid.eval_tile(running), "%d" % direction, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color.RED)
				_draw_tile(running)
				running = Grid.get_neighbour(running, direction)
			_draw_tile(running)
				
	if active_measure_mode == MeasuringMode.FOG:
		for blocking in Grid.blocking_tiles:
			_draw_tile_filled(blocking)
				
	# Draws measurements
	if from_pos != null:
		var tiles := []
		var to_pos := _get_hovered_tile()
			
		match active_measure_mode:
			MeasuringMode.NONE:
				pass
			MeasuringMode.DISTANCE:
				tiles = Grid.get_shortest_path(from_pos, measure_size, to_pos)
				var i := len(tiles)
				for t in tiles:
					i -= 1
					draw_string(default_font, Grid.eval_tile(t), "%d" % i, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color.CORNFLOWER_BLUE)
			MeasuringMode.LINE:
				tiles = Grid.get_line(from_pos, measure_size, to_pos)
			MeasuringMode.CONE:
				tiles = Grid.get_cone(from_pos, measure_size, to_pos)
			MeasuringMode.BURST:
				tiles = Grid.get_burst(from_pos, measure_size, to_pos)
				
		for tile in tiles:
			_draw_tile(tile, Color.CORNFLOWER_BLUE)

func deserialize(data: Dictionary) -> void:
	Grid.offset = data.offset
	Grid.tile_size = data.tile_size
	Grid.is_horizontal = data.is_horizontal
	Grid.blocking_tiles = data.blocking_tiles
	Grid.fow_effect = data.fow_effect
	%Fog.selected = data.fow_effect
	Grid.on_config_changed.emit(true)
	queue_redraw()
	_setup_shader()
	
func serialize() -> Dictionary:
	return {
		offset = Grid.offset,
		tile_size = Grid.tile_size,
		is_horizontal = Grid.is_horizontal,
		blocking_tiles = Grid.blocking_tiles,
		fow_effect = Grid.fow_effect,
	}
	
func handle_mouse_button(event: InputEventMouseButton, token: Token) -> void:
	_fog_draw_routine()
	if event.pressed and active_measure_mode == MeasuringMode.FOG:
		return
	if event.pressed:
		if token == null:
			measure_size = 1
			from_pos = _get_hovered_tile()
		else:
			measure_size = token.size
			from_pos = token.tile
	else:
		from_pos = null
	
func update_map_visibility() -> void:
	_on_visible_tiles_changed()
	
func _fog_draw_routine() -> void:
	var hovered_tile := _get_hovered_tile()
	if active_measure_mode == MeasuringMode.FOG:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovered_tile not in Grid.blocking_tiles:
			Grid.blocking_tiles.append(hovered_tile)
			_on_grid_changed()
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and hovered_tile in Grid.blocking_tiles:
			Grid.blocking_tiles.erase(hovered_tile)
			_on_grid_changed()
	for t in NetworkingSingleton.tokens.values():
		t.visible = t.is_token_visible()
	
func _make_hex(center: Vector2, size: Vector2) -> PackedVector2Array:
	var res: PackedVector2Array
	if Grid.is_horizontal:
		res = PackedVector2Array(UNITY_HEXAGON_HORI)
	else:
		res = PackedVector2Array(UNITY_HEXAGON_VERT)
	for i in range(7):
		res[i] = center + (res[i] - Vector2(.5, .5)) * size
	return res

func _draw_tile(tile: Vector2i, color: Color=Color.RED) -> void:
	draw_polyline(_make_hex(Grid.eval_tile(tile), Grid.tile_size), color)

func _draw_tile_filled(tile: Vector2i, color: Color=Color.RED) -> void:
	draw_colored_polygon(_make_hex(Grid.eval_tile(tile), Grid.tile_size), color)

func _get_hovered_tile() -> Vector2i:
	return Grid.get_tile(get_global_mouse_position())
	
func _on_grid_changed() -> void:
	queue_redraw()
	Grid.on_config_changed.emit(false)
	_setup_shader()

func _setup_shader() -> void:
	map_shadermat.set_shader_parameter("tile_size", Grid.tile_size)
	map_shadermat.set_shader_parameter("offset", Grid.offset)
	map_shadermat.set_shader_parameter("is_horizontal", Grid.is_horizontal)
	if Grid.fow_effect in [Grid.FOWEffect.HideAll, Grid.FOWEffect.NoSensors] and not NetworkingSingleton.is_gm:
		map_shadermat.set_shader_parameter("fow_color", Color(0, 0, 0, 1.0))
	else:
		map_shadermat.set_shader_parameter("fow_color", Color(0, 0, 0, 0.2))

func _on_visible_tiles_changed() -> void:
	Grid.update_visible_tiles()
	var n_tiles := len(Grid.visible_tiles)
	
	var visible_tiles_as_int_arr := PackedInt32Array()
	visible_tiles_as_int_arr.resize(n_tiles*2)
	for i in range(n_tiles):
		var tile: Vector2i = Grid.visible_tiles[i]
		visible_tiles_as_int_arr[i*2] = tile.x
		visible_tiles_as_int_arr[i*2 + 1] = tile.y
	
	for token in NetworkingSingleton.tokens.values():
		if not token.is_player:
			token.visible = token.is_token_visible()
	
	map_shadermat.set_shader_parameter("visible", visible_tiles_as_int_arr)
	map_shadermat.set_shader_parameter("visible_size", n_tiles)

func _on_x0_changed(value: float) -> void:
	Grid.offset.x = value
	_on_grid_changed()

func _on_y0_changed(value: float) -> void:
	Grid.offset.y = value
	_on_grid_changed()

func _on_sizex_changed(value: float) -> void:
	Grid.tile_size.x = value
	_on_grid_changed()

func _on_sizey_changed(value: float) -> void:
	Grid.tile_size.y = value
	_on_grid_changed()

func _on_horizontal_changed(button_pressed: bool) -> void:
	Grid.is_horizontal = button_pressed
	_on_grid_changed()

func _on_mm_button_pressed(button: Button) -> void:
	active_measure_mode = button.get_meta("mode", 0)

func _on_fog_item_selected(index: Grid.FOWEffect) -> void:
	Grid.fow_effect = index
	_on_grid_changed()
gRSRC                     PackedScene            ��������                                                  ..    HexMap 	   Camera2D    resource_local_to_scene    resource_name    script    shader    shader_parameter/tile_size    shader_parameter/offset    shader_parameter/is_horizontal    shader_parameter/visible    shader_parameter/visible_size    shader_parameter/fow_color 	   _bundled 	      Script .   res://scenes/networking/connection_manager.gd ��������   Script +   res://scenes/networking/WebSocketClient.gd ��������   Script    res://scenes/camera.gd ��������   Script    res://scenes/hex_grid.gd ��������   Shader    res://map.gdshader ��������
   Texture2D    res://icon.png ��Ng+�NC   Script    res://scenes/map.gd ��������   PackedScene     res://scenes/token_builder.tscn Jz��_&   Script    res://scenes/ClickHandler.gd ��������      local://ButtonGroup_nqy2e          local://ShaderMaterial_3an0l I         local://ButtonGroup_s71to �         local://PackedScene_hohxy          ButtonGroup             MeasureModeButtons          ShaderMaterial                   
     �B  �B   
     ��  �@	         
                                                      ?         ButtonGroup             Sizes          PackedScene          	         names "   u      main    script    Node2D    Socket    Node    UI    CanvasLayer    V    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    VBoxContainer    PanelContainer    layout_mode    Header    HBoxContainer    GM    size_flags_horizontal 
   MapLayout &   theme_override_constants/h_separation    columns    GridContainer    X    text    Label    SpinBox    allow_greater    allow_lesser    Y 	   SpinBox2    SX 	   SpinBox3    value    SY 	   SpinBox4    HorizontalGrid    size_flags_vertical    CheckButton    Fog    unique_name_in_owner    item_count 	   selected    popup/item_0/text    popup/item_0/id    popup/item_1/text    popup/item_1/id    popup/item_2/text    popup/item_2/id    popup/item_3/text    popup/item_3/id    OptionButton    SetMap    Button    UpdateVissbility    General 	   RoomName    expand_to_text_length    caret_blink    caret_blink_interval 	   LineEdit    Host    ConnectionStatus    Join    H    Margins %   theme_override_constants/margin_left $   theme_override_constants/margin_top &   theme_override_constants/margin_right '   theme_override_constants/margin_bottom    MarginContainer    None    toggle_mode    button_group    metadata/mode    Measure 	   DrawLine 	   DrawCone 
   DrawBurst    DrawFog    Control    mouse_filter 	   Camera2D    HexMap    measure_mode_button_group    Map    z_index 	   material    texture 	   Sprite2D    TokenBuilder    visible    ok_button_text    cancel_button_text    size_buttons    ExpectingMap    size    dialog_text    AcceptDialog    ClickHandler    hexgrid    camera    _on_x0_changed    value_changed    _on_y0_changed    _on_sizex_changed    _on_sizey_changed    _on_horizontal_changed    toggled    _on_fog_item_selected    item_selected    _on_set_map_pressed    pressed    _on_visible_tiles_changed    _on_host_pressed    _on_join_pressed    	   variants    5                                 �?                              x             y       width      �B      height              Horizontal       Transparent    	   Show Map          	   Hide All       No Sensors       Add Map       Update visibility       testing_ground       ?      Host       Offline       Connect          
                   []       Measure       Line       Cone       Burst       Fog                      ����                                                 Confirm       Remove          -               Drop Map here                                          node_count    )         nodes     !  ��������       ����                            ����                           ����                     ����         	      
                                   ����                          ����                          ����                                ����                                      ����                                ����            	      	                    ����            
                    ����            	      	                     ����                             !   ����         "         	                 #   ����                             $   ����         "         	              '   %   ����         &                       4   (   ����   )   	         &      *      +      ,      -      .      /      0      1      2      3                 6   5   ����         &                       6   7   ����                             8   ����         &                       =   9   ����   )   	         &            :   	   ;   	   <                 6   >   ����                             ?   ����   )   	                          6   @   ����                             A   ����         &                 G   B   ����         C      D      E      F                       ����                    6   H   ����         I   	   J            K                 6   L   ����         I   	   J             K                 6   M   ����         I   	   J         !   K                 6   N   ����         I   	   J         "   K                 6   O   ����         I   	   J         #   K                 6   P   ����         I   	   J         $   K                 Q   Q   ����               R                  S   S   ����      %                  T   ����      &   U          $       Z   V   ����   W   '   X   (   Y   )      *               ���[   +      \   ,   ]   -   ^   .   _   /               c   `   ����   a   0   b   1                  d   ����      2   e  @3   f  @4             conn_count    
         conns     F   	   $   h   g                 $   h   i                 $   h   j                 $   h   k                 $   m   l                 $   o   n                     q   p                 $   q   r                     q   s                     q   t                    node_paths              editable_instances              version             RSRC�_�D7�sclass_name MapSprite
extends Sprite2D

var url_base: String

var custom_headers := PackedStringArray([
	#"Access-Control-Allow-Origin: https://lancermap.fly.dev",
])

var is_requesting := false

var http_handler: HttpImageHandler
var wss_handler: WSSImageHandler

func _ready():
	if _should_use_http():
		if ProjectSettings.get("connections/in_testing"):
			url_base = ProjectSettings.get("connections/test_maps_url")
		else:
			url_base = ProjectSettings.get("connections/maps_url")
		http_handler = HttpImageHandler.new()
		add_child(http_handler)
	else:
		if ProjectSettings.get("connections/in_testing"):
			url_base = ProjectSettings.get("connections/test_socket_url")
		else:
			url_base = ProjectSettings.get("connections/socket_url")
		wss_handler = WSSImageHandler.new()
		add_child(wss_handler)
	#NetworkingSingleton.active_socket.connected_to_server.connect(
	#	download_map.bind("__test")
	#)

func set_map(image: Image, room_name: String="") -> void:
	if room_name == "": room_name = NetworkingSingleton.room
	var url := url_base + room_name
	if _should_use_http():
		texture = ImageTexture.create_from_image(image)
		http_handler.upload_img(url, image)
	else:
		texture = ImageTexture.create_from_image(image)
		wss_handler.upload_img(room_name, image)

func download_map(room_name: String="") -> void:
	if room_name == "": room_name = NetworkingSingleton.room
	var url := url_base + room_name
	if _should_use_http():
		http_handler.download_img(url)
		var image: Image = await http_handler.image_received
		texture = ImageTexture.create_from_image(image)
	else:
		wss_handler.download_img(room_name)
		var image: Image = await wss_handler.image_received
		texture = ImageTexture.create_from_image(image)

func _should_use_http() -> bool:
	return true
	#return OS.get_name() != "Web"

#func _should_use_http() -> bool:
#	return false
��@�eextends PointLight2D

var UNITY_HEXAGON_VERT := PackedVector2Array([
	Vector2(.25, 0),
	Vector2(.75, 0),
	Vector2(1, .5),
	Vector2(.75, 1),
	Vector2(.25, 1),
	Vector2(0, .5),
	Vector2(.25, 0),
])

var UNITY_HEXAGON_HORI := PackedVector2Array([
	Vector2(0, .25),
	Vector2(0, .75),
	Vector2(.5, 1),
	Vector2(1, .75),
	Vector2(1, .25),
	Vector2(.5, 0),
	Vector2(0, .25),
])

func _draw():
	_draw_tile_filled(Vector2i.ZERO)
	
func _make_hex(center: Vector2, size: Vector2) -> PackedVector2Array:
	var res: PackedVector2Array
	if Grid.is_horizontal:
		res = PackedVector2Array(UNITY_HEXAGON_HORI)
	else:
		res = PackedVector2Array(UNITY_HEXAGON_VERT)
	for i in range(7):
		res[i] = center + (res[i] - Vector2(.5, .5)) * size
	return res
	
func _draw_tile_filled(tile: Vector2i) -> void:
	draw_colored_polygon(_make_hex(Grid.eval_tile(tile), Grid.tile_size), Color.WHITE)
��ZH'��]���class_name Token
extends Node2D

var dragging := false

var uuid: int = -1
var size: int = 1
var tile := Vector2i.ZERO
var is_player := true
var sensor_range := 5

var is_online := false:
	set(x):
		is_online = x
		queue_redraw()

var is_spawned_by_local := true

@onready var sprite: Sprite2D = $Sprite
# Hacky af aproach
@onready var default_font = Control.new().get_theme_default_font()

signal data_changed(me: Token)
signal request_edit(me: Token)

func _ready():
	is_player = not NetworkingSingleton.is_gm
	Grid.on_config_changed.connect(_on_grid_config_changed)
	visible = is_token_visible()
	
func _draw():
	draw_string(default_font, Vector2.ZERO, "%d" % uuid)
	draw_circle(Vector2(0, -8), 5, Color.GREEN if is_online else Color.RED)

func _input(event: InputEvent):
	if event is InputEventMouseMotion and dragging:
		if move_to(get_global_mouse_position()):
			data_changed.emit(self)

func can_manipulate() -> bool:
	return is_spawned_by_local or NetworkingSingleton.is_gm

func is_mb_hovering() -> bool:
	if not sprite.get_rect().has_point(sprite.to_local(get_global_mouse_position())):
		return false
	if Grid.get_tile(get_global_mouse_position()) not in get_covered_tiles():
		return false
	return true

func deserialize(data: Dictionary) -> void:
	print("Deserialize :", data)
	sprite.transform = data.transf
	size = data.size
	tile = data.tile
	is_player = data.is_player
	sensor_range = data.sensor_range
	position = Grid.eval_tile(tile)
	visible = is_token_visible()
	queue_redraw()
	
func serialize() -> Dictionary:
	return {
		tile = tile,
		size = size,
		transf = sprite.transform,
		is_player = is_player,
		sensor_range = sensor_range,
	}
	
func deserialize_image(data: PackedByteArray) -> void:
	var img := Image.new()
	img.load_png_from_buffer(data)
	set_sprite(ImageTexture.create_from_image(img))
	
func serialize_image() -> PackedByteArray:
	return sprite.texture.get_image().save_png_to_buffer()
	
func set_add_transform(transf: Transform2D) -> void:
	sprite.transform = transf
	
func get_add_transform() -> Transform2D:
	return sprite.transform
	
func set_sprite(texture: Texture2D) -> void:
	sprite.texture = texture
	
func get_sprite() -> Texture2D:
	return sprite.texture
	
func is_token_visible() -> bool:
	if is_player:
		return true
	if NetworkingSingleton.is_gm:
		return true
	if Grid.fow_effect == Grid.FOWEffect.ShowAll:
		return true
	return Grid.is_in_line_of_sight(tile, size)
	
func move_to(pos: Vector2) -> bool:
	var new_index = Grid.get_tile(pos)
	if new_index != tile:
		tile = new_index
		position = Grid.eval_tile(tile)
		visible = is_token_visible()
		return true
	return false

func get_covered_tiles() -> Array[Vector2i]:
	return Grid.get_covered_tiles(tile, size)

func _on_grid_config_changed(from_remote: bool) -> void:
	position = Grid.eval_tile(tile)
��\��FRSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name 	   _bundled    script       Script    res://scenes/token.gd ��������      local://PackedScene_50xla          PackedScene          	         names "         Token    script    Node2D    Sprite    show_behind_parent 	   Sprite2D    	   variants                             node_count             nodes        ��������       ����                            ����                   conn_count              conns               node_paths              editable_instances              version             RSRC����Qclass_name TokenBuilder
extends AcceptDialog

@export var size_buttons: ButtonGroup

var token: Token
var is_confirmed := false

@onready var transform_preview: TransformPreview = $V/Sprite/TransformPreview
	
signal setup_complete
signal request_remove(token: Token)

func _ready():
	size_buttons.pressed.connect(_on_size_button_pressed)
	add_button("Kill", true, "kill")

func setup(p_token: Token, raw_texture: Texture2D=null) -> void:
	token = p_token
	var texture: Texture2D
	if raw_texture != null:
		var img := raw_texture.get_image()
		var png_buffer := img.save_png_to_buffer()
		while len(png_buffer) > 0xFFFF - 9:
			img.shrink_x2()
			png_buffer = img.save_png_to_buffer()
		texture = ImageTexture.create_from_image(img)
		token.set_sprite(texture)
	else:
		texture = token.get_sprite()
	
	transform_preview.set_transform(token.get_add_transform().affine_inverse())
	#transform_preview.set_transform(Transform2D.IDENTITY.scaled(Vector2.ONE* 1000))
	#_on_transform_changed(transform_preview._transf)
	
	var relevant_button = size_buttons.get_buttons().filter(func(x): return x.get_meta("size", 0) == token.size).pop_back()
	if relevant_button != null:
		relevant_button.button_pressed = true
	#transform_preview.set_token_size(token.size)
	$V/IsPlayer.button_pressed = token.is_player
	$V/Sensors/SpinBox.value = token.sensor_range
	$V/Sprite.texture = texture
	transform_preview.sprite_size = texture.get_size()
	popup_centered()

func set_map_parameters() -> void:
	transform_preview.tile_size = Grid.tile_size
	transform_preview.is_horizontal = Grid.is_horizontal

func _on_size_button_pressed(button: BaseButton) -> void:
	var size: int = button.get_meta("size")
	transform_preview.set_token_size(size)
	if is_instance_valid(token):
		token.size = size

func _on_confirmed() -> void:
	is_confirmed = true
	setup_complete.emit()
	token.data_changed.emit(token)

func _on_canceled() -> void:
	is_confirmed = false
	setup_complete.emit()

func _on_transform_changed(transf: Transform2D) -> void:
	if not is_instance_valid(token):
		return
	token.set_add_transform(transf.affine_inverse())

func _on_custom_action(action: String) -> void:
	if action == "kill" and is_instance_valid(token):
		request_remove.emit(token)
		hide()

func _on_is_player_toggled(button_pressed: bool) -> void:
	$V/Sensors.visible = button_pressed
	token.is_player = button_pressed

func _on_sensors_changed(value: int) -> void:
	token.sensor_range = value
-��sHRSRC                     PackedScene            ��������                                                  resource_local_to_scene    resource_name    script 	   _bundled       Script    res://scenes/token_builder.gd ��������
   Texture2D    res://icon.png ��Ng+�NC   Script "   res://scenes/transform_preview.gd ��������      local://ButtonGroup_mvjau �         local://PackedScene_kion1 �         ButtonGroup             Sizes          PackedScene          	         names "   ;      TokenBuilder    title    size    visible    script    size_buttons    ConfirmationDialog    V    offset_left    offset_top    offset_right    offset_bottom    VBoxContainer    H    layout_mode 
   alignment    HBoxContainer    Label    text    Size1    toggle_mode    button_group    metadata/size    Button    Size2    Size3    Size4    Sprite    texture    expand_mode    stretch_mode    TextureRect    TransformPreview    anchors_preset    anchor_right    anchor_bottom    grow_horizontal    grow_vertical    Control 	   IsPlayer 	   CheckBox    Sensors    SpinBox    size_flags_horizontal    allow_greater    _on_canceled 	   canceled    _on_confirmed 
   confirmed    _on_custom_action    custom_action    _on_gui_input 
   gui_input    _on_transform_changed    transform_changed    _on_is_player_toggled    toggled    _on_sensors_changed    value_changed    	   variants             Setup Sprite -   #  �                                  A    ��C     �C                  Size:       ½,1       2       3             4          &   Click and drag to align token to grid                           �?               Is player Character       Sensor Range
    
         node_count             nodes     �   ��������       ����                                                    ����         	      
                             ����            	                    ����            
                    ����                              	                    ����                                                  ����                                                  ����                                                  ����                                ����                               	       &       ����      	   !      "      #      $      %                       (   '   ����                             )   ����                          ����                          *   *   ����         +      ,                conn_count             conns     1           .   -                      0   /                      2   1              
   
   4   3              
       6   5                     8   7                     :   9                    node_paths              editable_instances              version             RSRC���.!ĭclass_name TransformPreview
extends Control

const UNITY_HEXAGON_S1 := [
	Vector2(.25,  0),
	Vector2(.75,  0),
	Vector2(  1, .5),
	Vector2(.75,  1),
	Vector2(.25,  1),
	Vector2(  0, .5),
	Vector2(.25,  0),
]

const OFFSETS = [
	[
		Vector2(0, 0)
	],
	[
		Vector2(   0,    0),
		Vector2( .75,  0.5),
		Vector2( .75, -0.5),
	],
	[
		Vector2(   0,   1),
		Vector2(   0,  -1),
		Vector2(-.75,  .5),
		Vector2(-.75, -.5),
		Vector2( .75,  .5),
		Vector2( .75, -.5),
	],
	[
		Vector2(-.75,   .5),
		Vector2(-.75,  -.5),
		Vector2(   0,    0),
		Vector2(   0,    1),
		Vector2(   0,   -1),
		Vector2( .75,  1.5),
		Vector2( .75,   .5),
		Vector2( .75,  -.5),
		Vector2( .75, -1.5),
		Vector2( 1.5,    0),
		Vector2( 1.5,    1),
		Vector2( 1.5,   -1),
	]
]

var _transf := Transform2D.IDENTITY

var origin := Vector2.ZERO
var right := Vector2.RIGHT

var dragging := false

var _token_size := 1

signal transform_changed(transf: Transform2D)

var draw_transf: Transform2D
var inv_draw_transf: Transform2D

var tile_size: Vector2
var is_horizontal: bool

var sprite_size: Vector2

func _draw():
	var draw_scale_vec  := tile_size*size/sprite_size*.5
	var draw_scale = draw_scale_vec[draw_scale_vec.min_axis_index()]
	draw_transf = Transform2D(0, Vector2.ONE * draw_scale, 0, Vector2.ONE * size.x/2)
	inv_draw_transf = draw_transf.affine_inverse()
	
	var hex = PackedVector2Array(UNITY_HEXAGON_S1)
	var offsets = OFFSETS[_token_size - 1]
	draw_circle(draw_transf * Vector2.ZERO, 2, Color.RED)
	for offset in offsets:
		for i in range(len(hex)):
			var pt = (2*(UNITY_HEXAGON_S1[i] + offset) - Vector2.ONE)
			#pt.y *= tile_size.x / tile_size.y
			if is_horizontal:
				pt = pt.rotated(PI/2)
			hex[i] = draw_transf * (_transf * pt)
		draw_polyline(hex, Color.RED, 2, true)
	if dragging:
		draw_line(
			draw_transf * origin,
			draw_transf * (origin + right),
			Color.RED
		)
	
func set_transform(transf: Transform2D) -> void:
	_transf = transf
	right = transf.x
	origin = transf.origin
	
func set_token_size(p_size: int) -> void:
	_token_size = p_size
	queue_redraw()
		
func _snap_to_axes(inp: Vector2, tolerance: float=0.1) -> Vector2:
	if Input.is_key_pressed(KEY_ALT):
		return inp
	if abs(inp.x) < tolerance:
		inp.x = 0
	if abs(inp.y) < tolerance:
		inp.y = 0
	return inp
	
func _on_gui_input(event: InputEvent) -> void:
	var draw_scale = (sprite_size/tile_size).x
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			origin = inv_draw_transf * event.position
			if origin.length() < 0.1 * draw_scale and not Input.is_key_pressed(KEY_ALT):
				origin = Vector2.ZERO
			dragging = true
		else:
			right = _snap_to_axes(inv_draw_transf * (event.position - origin) /2, 0.05*draw_scale)
			_transf = Transform2D(right, right.rotated(PI/2), origin)
			transform_changed.emit(_transf)
			dragging = false
			queue_redraw()
	elif  event is InputEventMouseMotion and dragging:
		right = _snap_to_axes(inv_draw_transf * (event.position - origin) /2, 0.05*draw_scale)
		_transf = Transform2D(right, right.rotated(PI/2), origin)
		queue_redraw()
��I�t�RSRC                     Environment            ��������                                            d      resource_local_to_scene    resource_name    sky_material    process_mode    radiance_size    script    background_mode    background_color    background_energy_multiplier    background_intensity    background_canvas_max_layer    background_camera_feed_id    sky    sky_custom_fov    sky_rotation    ambient_light_source    ambient_light_color    ambient_light_sky_contribution    ambient_light_energy    reflected_light_source    tonemap_mode    tonemap_exposure    tonemap_white    ssr_enabled    ssr_max_steps    ssr_fade_in    ssr_fade_out    ssr_depth_tolerance    ssao_enabled    ssao_radius    ssao_intensity    ssao_power    ssao_detail    ssao_horizon    ssao_sharpness    ssao_light_affect    ssao_ao_channel_affect    ssil_enabled    ssil_radius    ssil_intensity    ssil_sharpness    ssil_normal_rejection    sdfgi_enabled    sdfgi_use_occlusion    sdfgi_read_sky_light    sdfgi_bounce_feedback    sdfgi_cascades    sdfgi_min_cell_size    sdfgi_cascade0_distance    sdfgi_max_distance    sdfgi_y_scale    sdfgi_energy    sdfgi_normal_bias    sdfgi_probe_bias    glow_enabled    glow_levels/1    glow_levels/2    glow_levels/3    glow_levels/4    glow_levels/5    glow_levels/6    glow_levels/7    glow_normalized    glow_intensity    glow_strength 	   glow_mix    glow_bloom    glow_blend_mode    glow_hdr_threshold    glow_hdr_scale    glow_hdr_luminance_cap    glow_map_strength 	   glow_map    fog_enabled    fog_light_color    fog_light_energy    fog_sun_scatter    fog_density    fog_aerial_perspective    fog_sky_affect    fog_height    fog_height_density    volumetric_fog_enabled    volumetric_fog_density    volumetric_fog_albedo    volumetric_fog_emission    volumetric_fog_emission_energy    volumetric_fog_gi_inject    volumetric_fog_anisotropy    volumetric_fog_length    volumetric_fog_detail_spread    volumetric_fog_ambient_inject    volumetric_fog_sky_affect -   volumetric_fog_temporal_reprojection_enabled ,   volumetric_fog_temporal_reprojection_amount    adjustment_enabled    adjustment_brightness    adjustment_contrast    adjustment_saturation    adjustment_color_correction        
   local://1 Q	         local://Environment_o1yc0 e	         Sky             Environment                          6         ?      ��?B      \��>R               RSRC�(4��Z�I�s�e< GST2   @   @      ����               @ @        �  RIFF�  WEBPVP8L�  /?��m��4�~X��3���˺����r��
0>�����ݕ�N�#����J�m[m���?$�aj�LO��=�b6��l�m��r�S ��,O��C`f�V��A7Ҫdb7t!mH�,��I�mN���'���	g$i�F�Y�c�o�<�<�nǞF�������}�8#�32@��0�����*_��+�be?A��e#l�rP�I��|��<3fe?��E�Xt�E��e�g�T&E&e�T{ ̢�c�!I��g��L�㙁�I
~����a�h�I����KM�o�@��Wf��
����?sPd&E L>�0�Mo�,r�`��{e���ǁ0F�}-��sA  ���q�B $�¹PW���K?�VOg�-H��N�F�y���)	�0շ� ;u��}���d!n���~�-f�􃓛q~�uSP5{�D�=Z/������5��)#�fO��_r'7�M?`œpm�Op��u���p�%�/����#rŵ�?x�+��A�w1#����%� ��KN.H����a��0A���+��$M�GO������?�������~�q��
��	+?[h�8�����#�lV�O�Gp�#���C������S�x�ړ�� �w�'�eRT��m�M���΍��nSC@s�(��Zg! O���|������poD-�]v�/�B�N�܅�$��܏�m YX��);Q��h���s �:_��	0N7���1�H�`�kx?��@�'�>'�x"S��L�	��
qn�q>�iw�o|��I�[<�y�Q_�|��ι5>0BWE��J��T͟'aX��)�gF��,����#<��%8	���B@y:�s�j�w��$����UK�ͬ����a��_p3���!5{./���K�ӗ�%3{.��}٧�,YL{���#��b�Y�){ǝ' ���;�w��4�m�ӛ�EI,�v���+3Ѩ��L_���L4:<V�e�k���g/��H%�)bI7	B��堳��E$�Ҷ���m"	D�(� tV���$�":={A���S�-e�*�%e�)"Y�~� x�3�|F�~��,ԁ���Te���9E0�2~C@���Te(���-�ے,H�opXo�)�n�VF��+�7�j_�0��U�2�EGղ����u���ecF �}93�3�!`J�o�L�Nb���"�i <����[+xO�teL(r�����΄"��P���`��X<���Uܒ@)H�2>V�G��tMp��7YJ�z�X�e�*r �[r���(��O7�e�2={�|���=��Ap>z�"|�  �e��Ӎ�$Fir�|˙���۾U�[%��|˙{�&/0�p�wQK�f�k%[��>��}�w����y�W{�����78+��^c�P�YةkIo�n��P:<V4j^/:�������cE]uv.lՍ�����b(u�|�r��f5_�݉�~k!@�~ki��d5_��xS>}Q?�{/(�,���n�l @.e�Gܒ�hP1y"��qK���8\ `�l��z=�:�}fBR	Խ�UL��··x@@�. �t��
��Q1y�{=C@	�D0��st�:��h����� �p�99����V�@���!~4�7��J�>��y��鰫�v��t�����8Z<��iߨ^O���B���ݺvv.���ٌ���.��sa�����B��^O�oԃ�q� Լ\ �"�)���=�Q��n��s��F�:���ҡ�;���M���e� W4ʤHG�j�5L��]�r�����b-�"=����ɇX�ۉQo'��x'�eR�+a��d�A�|�k�81�"��4��G=l\sŇ�L��%.�S5����@�ɩ�C���D.h��E��I��S	�7�:_�#�I�rI	�3p�b �[�U5�d�m��]�U�\���k�ٵ�K��ɷx�~��w�׶Vc��U5�  fa�����%%�4$�Tt�h(VFO���@�N����R_�6
<�,�C[��>7�$���2x�^}�V_�y�^e:�QI8�ܰ|O����eRdb��/f�l�a �Yt� �-�� ,���C���{�<vO��@����pg�a��=e�)�=�yS��H8#�'㙽l��W&���"��^6�g����)��pF��� |@�I���0���O���4rͺ;ϼ@x�g^�����5��`|�� x��[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://cbdnjpjhir6el"
path="res://.godot/imported/icon.png-487276ed1e3a0c39cad0279d744ee560.ctex"
metadata={
"vram_texture": false
}
 �7��)�fz���%shader_type canvas_item;

#define MAX_VISIBLE_TILES 2048

const ivec2 NEIGHBOUR_LOOKUP[] = {
	ivec2(0,-1),  ivec2(1,-1),  ivec2(1,0), ivec2( 0,1), ivec2(-1,0), ivec2(-1,-1),   // from % 2 (0, 0)  not horizontal
	ivec2(0,-1),  ivec2(1,-1),  ivec2(1,0), ivec2( 0,1), ivec2(-1,0), ivec2(-1,-1),   // from % 2 (0, 1)  not horizontal
	ivec2(0,-1),  ivec2(1, 0),  ivec2(1,1), ivec2( 0,1), ivec2(-1,1), ivec2(-1, 0),   // from % 2 (1, 0)  not horizontal
	ivec2(0,-1),  ivec2(1, 0),  ivec2(1,1), ivec2( 0,1), ivec2(-1,1), ivec2(-1, 0),   // from % 2 (1, 1)  not horizontal
	ivec2(0,-1),  ivec2(1, 0),  ivec2(0,1), ivec2(-1,1), ivec2(-1,0), ivec2(-1,-1),   // from % 2 (0, 0)      horizontal
	ivec2(1,-1),  ivec2(1, 0),  ivec2(1,1), ivec2( 0,1), ivec2(-1,0), ivec2( 0,-1),   // from % 2 (0, 1)      horizontal
	ivec2(0,-1),  ivec2(1, 0),  ivec2(0,1), ivec2(-1,1), ivec2(-1,0), ivec2(-1,-1),   // from % 2 (1, 0)      horizontal
	ivec2(1,-1),  ivec2(1, 0),  ivec2(1,1), ivec2( 0,1), ivec2(-1,0), ivec2( 0,-1)    // from % 2 (1, 1)      horizontal
};

struct GridConfig {
	vec2 tile_size;
	vec2 offset;
	bool is_horizontal;
};

uniform vec2 tile_size;
uniform vec2 offset;
uniform bool is_horizontal;

uniform ivec2 visible[MAX_VISIBLE_TILES];
uniform int visible_size = 0;

uniform vec4 fow_color: source_color = vec4(0, 0, 0, 0.5);

int mod2(int x) {
	return abs(x) % 2;  // Not sure how it handles negative integers
}

float lenght_sqr(vec2 v) {
	return dot(v, v);
}

vec2 eval_tile(ivec2 inp, GridConfig config) {
	vec2 inpf = vec2(inp);
	if (config.is_horizontal){
		return vec2(
			(mod2(inp.y) == 1 ? inpf.x + 0.5 : inpf.x) * config.tile_size.x + config.offset.x,
			inpf.y * .75 * config.tile_size.y + config.offset.y
		);
	} else {
		return vec2(
			inpf.x * .75 * config.tile_size.x + config.offset.x,
			(mod2(inp.x) == 1 ? inpf.y + 0.5 : inpf.y) * config.tile_size.y + config.offset.y
		);
	}
}

ivec2 get_neighbour(ivec2 inp, int neighbour_idx) {
	int index = neighbour_idx + mod2(inp.y)*6 + mod2(inp.x)*12 + int(is_horizontal)*24;
	return inp + NEIGHBOUR_LOOKUP[index];
}

ivec2 _get_tile_estimate(vec2 inp, GridConfig config) {
	vec2 del = (inp - config.offset) / config.tile_size;
	if (config.is_horizontal) del = del.yx;
	del.y += 0.5 * sign(del.y);
	del.x += 0.25 * sign(del.x);
	int x0 = int(del.x * 1.3333);
	ivec2 p0 = ivec2(x0, int(mod2(x0) == 0 ? del.y : del.y - 0.5));
	if (config.is_horizontal) p0 = p0.yx;
	return p0;
}

ivec2 get_tile(vec2 inp, GridConfig config) {
	ivec2 p0 = _get_tile_estimate(inp, config);
	float min_dist_sqr = lenght_sqr(eval_tile(p0, config) - inp);
	//for c in [p0 + Vector2i(0, 1), p0 + Vector2i(1, 0), p0 + Vector2i(1, 1)]:
	for (int i=0; i < 6; i++) {
		ivec2 c = get_neighbour(p0, i);
		float dist_sqr = lenght_sqr(eval_tile(c, config) - inp);
		if (dist_sqr < min_dist_sqr) {
			p0 = c;
			min_dist_sqr = dist_sqr;
		}
	}
	return p0;
}

void fragment() {
	GridConfig config;
	config.tile_size = tile_size;
	config.offset = offset;
	config.is_horizontal = is_horizontal;
	vec2 pixel = (UV - .5) / TEXTURE_PIXEL_SIZE;
	bool is_visible = false;
	ivec2 current_tile = get_tile(pixel, config);
	for (int i=0; i < visible_size; i++) {
		if (visible[i] == current_tile) {
			is_visible = true;
		}
	}
	
	vec4 sampled = texture(TEXTURE, UV);
	if (is_visible){
		COLOR = sampled;
	} else {
		COLOR.rgb = mix(sampled.rgb, fow_color.rgb, fow_color.a);
		COLOR.a = sampled.a;
	}
	
	//COLOR.rg = fract(vec2(_get_tile_estimate(pixel, config)) / 3.0);
	//COLOR.rg = fract(vec2(get_tile(pixel, config)) / 3.0);
	
	//vec2 error = pixel - eval_tile(get_tile(pixel, config), config);
	//COLOR.rg = abs(error) * 0.01;
	
	/*ivec2 index = ivec2(6, -6);
	float error = 1.0;
	for (int i=0; i < 6; i++){
		ivec2 n = get_neighbour(index, i);
		error *= step(0.5, abs(length(eval_tile(n, config) - pixel)) * 0.1);
	}
	if (index == _get_tile_estimate(pixel, config)) {
		COLOR.rg = vec2(0);
	} else {
		COLOR.rg = vec2(error);
	}*/
}
GST2   �  %     ����               �%       R  RIFFR  WEBPVP8LR  /�	�9�m��9��${�	p�#�JL��)��m�N��Oާ4@�?t@�#y�{7�H�M[k�g��?럚B��Ϟ�W�����׿�4 R��9��� �@�H�� H�C!QC3�S�
A��I+���
��� ��E�ӌ	S�i�b���T�LR�)%(N ҊJ��ZШN 
Q˯���L��
 @- )��'�۪SV�����oq|�<���§��oַ����<O�޻�x�fMΦ�qi\tusq�8�����!�����y��?��Æ����?Ǉ_��#�e$��s�x�jѤ�x6a�P@�-�t��ċ=�{ѝ�������c��c�s��}��eҶ�w�u��~D6XkѲ�'I`��!	e��G�U�*���p�[�pإ/��.�9�am48�i��i��5�j�[��w�[,m#IRR]=��="bP�mp�7�.����Ro>�oBa�Iڇֻ}@�-�"k�.�����L�����뻗���;����-��}���ʯ2+����8n	�<I_Fl_�\�n[;��_,��&�!�k��Y��7��j�G
��wF�m۶��
��ζǑdۖ��e�G�^Ax��a]�F��zG����Q�U@�;f��g?)�0`D�_�#I�$E������ݽБ$ɱ},��	�3�k�� ���J_&�@��.�K��Te��V/���Jn#	�$��0'!��gv�����sܸ�-�L���W�]����b�� �c)Y��!1�[��5���m�佈�p2�~�yde����?�R�0����Hr$������ޞ���f�6��DQ�����0I�!۶��cS2o��T�Bj$��OV��C�x���aK{D��m$HR%u׬��P�����,yt�k�C��2`m L`CP���鑗N�F� ��	�x8���{��t�"��m$GR�cv7��#(ɶ��d�Ë��5��(��T_j��d�T�������pD��8��H����_Z���[���������������_�_�_�_��'%��ywt~���w���J?J)�莎��{������RZ<���V�|��?��h��_���;E��w�xh��-)�A���m_����%O�?޶������Z�d���mW���i%/�?�6U�����R�b���mO����%'�?޶$�����TrR���mG�����%'�?�6$����;Urr������_�a�E��7W���ݻ%�?�<Z�u��\Xt�x��QB����P�x�K���9����������4�]��������uǎ���{@�ǻ�G)%F��8�niv׻ql��1�%����+!CAH��a�P�|�8)�rI�������B��8�n�/�.�n���떄�Y���

›5�ޅ�~u�w�]�$����U�2�Au����݅pH	�6��/�fIx��j��'d(��"��)C���GEW,	7xC���_=��� ����*5�ۻ����%�o��0B��8�n��ԡn��L��K��0uB
� �)�c����sE�.	OxCI/d(�톑���������$\�V4��� �ۊ�1T�}���q	u;w��[��꾟���	
※��Zb����+Eg-	gxK�N#d(��� kuw׊�Y����q��5d���n��j�K��)�J����ػK�ڃBݾ���ח�?�cʢ�N���{������P�o7��z���ʃ�c�:�0ܼ
u�v{���+y_�z~@
uv{/���Z���`w�3���������i�n��ZY��1F���6_��bR���n�n�E��,����Xt*Ra�R�n�n�E�B�,	���Y�*Vّ�Aݬ�N�T++�D���k��heC�
u�v�-�,Ȓ�n�n�%��UY:������T��!+��1�=���Xed%P7e��S!������]�*f���A݌��K���Y!ԍ����TҊ�}��dr���!��n�Q��ѿ���>�������39u�f�7�����w�����l��a8"�x.����"3.���"=�j�O��,��a�P����f�z'D� �~��o�P��}�f���?�#i����{ν7�͑���:2h��5H݅�~��ݧ�nV���CA=��gO��{o6��ޛ�%td��w����݅pH	j��O��l�����y$�w��:����ߛ��<��##c�F���ԗ�BX���ݧ�n���CA<�ָ%�1��ߛ��L��#"@��MEj��>w�ֻ�{��E�������-E������n.�Б����!UHj��O�ݬ����"�HZ��Z�E������n6j��!@��MA���v�޻�z�yE�������9���ߛ��|���:@"C�F�F��ݼ�>�w���s��#i��K�3��ߛ�� h+~>��!B��mE��B0�v7_�O������"�H��v.y���{���^�ؠ3"C�F�ۊ�%v�=�>�w���K��#i�۩���ߛk�V`�΀� �nR� P��}��f㽗=�G�67��==��7����]4��5�����������{/}(����:�f����ݧnK@�+ #�F����=(�>v����w�����4ս��O	��w��m��ͨ�Ի�Hݼ	
��ݧ�n�ݻ�CJ������^�����-
�nt������P��=6�+��G}K��� �K�X����B�B�w�s�ݝ�������.�@���8��w���^xf���{�Ԟ
�]�d��#��k�� z?��uN��Px�'+A|�{W�<��{h<��|^�-@����#�?�1�P��ݷ���N�!�ޥ��մ�H�P{�ݵ��.b�aA�"@�gw�Rv��M�fC�����J��b6)Ծvw*���ThR�HѠ���K�=9m��m/�� z�L�hP�H����C�;�mA�l{(� H��.��ќؐ�B�qww�sr��ǳ}�;����!лd@cbA���ݝ���u#"��K^�a
�w�����j����������Y���7Az�K@hHjH	����#Y?yo"��o7͒7� ��%04#e�$P{�ݍ��ܷ)e}fɟo�en�ޥ �R"�}��D�O\H�]�֒ot�u�P�R	M�)��ww!˓GD����|�\��z�I�h@�H	����9�|���W�-F��>Rb�K$��?��_�3��K}��=��S����}2%�<^v%snw��랄�%��w��랐8)���N" =!���N& �B��k�L	��p�Rί_݊s+�=�$N��~�Np��@��{����8��U�7����b�I�H9��}��u�u߻ܚ ��7~o~tS{ �q���ڲ�����G�{�P+�^�[�;�����{󤛧���*@/k�"C���кG����j���q�����o6��xo��}�fik�
��V)��B�ЪG�{�_C��{Mn���|��i��M���������U��zz36RW��B�КGr���Ԛ����y�w��:�Λc�+~�{���R7Z��U�=NF��X�H}����x$���)C��{mn���l���;�E��	�߻[�P�>�W% zZ
�E��?��ݕԠ�߽>��{o��V��^���w׺�
�����BCjˡُ�rw5u��w�ѭ�ޛ축���W�����ݽn�:!D�n�BA�ۡ���p�!��w�ӭ���N�<g���^e'�7~�.vCI/�P#�b��f>��ݦԠ�Z@ͼ{�nM��\�����Jxo����V+�VD�͍X�H=C����H�w�߇�K�yw�׭��붕�ǢW�������n����O>��Л�X��94�\�6�5��5���{Sݶ��Z�ʖ������-U:��W��X��;4���@͹{�n��P���=�J'�7~�.wKj�D���Ԑ�=4��솂A͸{�n��V�?_3�؊^�%�������`������	K	)k�C��d7j��������W���)٤��`<�{���zwLY4�ڶF��e�Ĉ?���pP������[�^/<2zݤ�^��xo�ޏz�PW���on^� �}!(�����G}K��� ���lm]y������������^?����R��}�^�����^xf��.���Gt-�g��{�<Yi��x�Z'���O�w��� ޻��JC_��U$��Ϗ�'�K�����޻s�_{�A��w��n'M�x�̵_L�'�����/aӪ�B��`��n��26�z)�.���/eӨ�B��d1����lr�Vv��Y�w�����j���j���].��ǲ"��b��n�-�m%ip�%�z-R]-��[�v��ǳ}�;����!л\"Q�eA���zwܮ�n�f�;����@�rIZ�W����-p�n�[�_�%��{�w�$���T�K�����	�Kѷ�f�L�ޥ��z�2R].��[�vߦD�Q��%����1�z�Ib��JHu���n�ہ����Z򍮴N� �]&�7[#�����n��8Eo+���ރ�.���іHu��ނ�>\D�+���m)��%�����i�K}��=��S���.�L&���s/��9�;��uOB⎒\�;��uO����h�z'��h�z' C!�޵N�@�	�w%KJ��nB�7��)�O<�W��8�o~_{�c���nM��������6��N������Wr��;��{�ߛ�����N�^<�����X�G.<�f���?��n½��x�{��xsp�^��]���jw��O�Yё+��w�}���poI`<�{��x��������.�C�{��C�Epd�Cm�݇���~r��3�o^�^�K�2���z2�_�a��EJ�|d�Cm�݈ȧE���L����Wܒ�{��x3Q���|!�ݫ����Cm���_	=ޝ��V�W�xo���o.���/F���Z!|���[4��ǻ3�o�^qJ��ݔo6jГ��D���z!��P�o�L�s�g����y-z�]�xo��x�Q��� =�j�+��o
xd�Cm��"��=��ÿ%��9���)� h+~>��#�d!B�]M���X�#j��.�|A�������W���{�7e��l�ۑ����k1��P�owQ�C�wg�� E�l%����nʀ�X��!os�-�b8�ࡶ��������ߒ8����ݔo;�C_G��nk�R9�衶��%��x����f���2�m	�e䑰vۃ���)w�9b{�G�n/�-��s�7�wS�m�������pv#AK��oK������O��n�[����ݔ<oQ��p�:4��X�ψ�����e�+�,�A���<|7����kE�� �����#�����!�}���)��=�����?�&O{����Ż��g�ؓ?�w3�������n����B����?���8�9��>О�w?>�����hw�Iy-h{����׿��#�(����E�PD�/$�=�|�v_L�{yC!ﾠ�}��n��j���j���}b ��:��z�[����P�A��}j ��6�Nz7\�ǳ}�;����!��� �e�p�n��Y�%/�0��� ]}�Ep�n�DDnEe��~�M�ާ��j#/��w�eB�R���Y���i0��ȋa��|�QF�g���VZ�� �}R ��4� *�0!Qv�[K�ѕ��@�O
���GB�w��8Eo+���ރ�>% F��<��w&"�}�Q򶏔X�����3!�=��S����}2%�<^v%snw��랄�%��w��랐8)���N" =!���N& �B��k�L	��p�,��8h��!���T��gi�/��K�.zk� o����U����w�5��G�D�o�Do���B�d3�6,�Ft��������;����Л��m�^��zKb�f�A)4���I`<��=�����W��]�p�0zCR>hD3�݊^9��[��y���{��Ѫv�z��* Q�7 �F4�ۥ�s�w�����:�j�Q�zXU ���X��h�7��k�[������ ����[(�F4֛[�ʭ�3������N8!���H��h�7����9����{u�Q$����[ �F4؛S�_�̀���:�V+FN�%���A#��]�[���{u�-�}?�ɇ� .�z;�|ЈF{g�╼c�{��^zK�N/��6J���N��������W��I�J�ĽR>hDӽ���V�:�f��ƿ7�wJ�t�*�wE��h�wﰔ�f����7����c�����ޙ����I��%�Y/<2z�{�ߛ��;ԕ���	�Lh�����r ���lm]y�{p=x�aۻ!��^?���1���C��׎Y/<3z�{Wƌ=�S}-��g��{�<Yi��x�Z'���O�w��� ޻��JC_���M zx�J�ke*B�+p��b����r:},9�>��\%�_ͶZ�?R ��e�*dA���� λbF�RV�x�/z璿�>� zW�HT�""��K^�a
�w�LZ��ȭ�̒�Ͻ	һR&��քȥ��M��&H�J���ZS"�(�̒?�J��@��db*m�D�Eo-�FWZ�o ���Q��^W�-"�����z޻
H�a��~7�P���W�-F��>R⽫�4,B��Mm�"ׄ�W�̒O� ޻H+����5�L�\Sb��eW2�v޻H���.��\HI.�x�ҟ2B��]T#p>R�K~��~w9-��]�SA���Ki C!��%>�Z���6% �N�K{�~�� \�:�0xo�{SV��#-j�n`7������,N���
��A���{+�rF��8�w�t�m�w�׫�Pyq��{G �xo�{S&�e���q��F��O�f�3|��h�����~����{Y�.7"�����ow��t�WRT^\���I`<?�������]fD}�Q�[-ؑ�3��娼�@ｓ�?�������{��;߈���~�J<��������{�$f�M>��S���G�}d?{�*1�矟 �|Ho���@ｓ�/��vM���{ ��|v�ŋ���7@ޛ�,�w3�$��n)#��wOl<{�C<�FH{;@2 ��;�3�N��ى3O��{���y'  �!yd�x��CF��{'qY	��Ò�{�M;�����;A�~�,���{'�{�xs�C��=�f��PV�`�p�f��t���Il��P޼��{���I'0T���Α��[�Đ	���I�"�pޜ�!��wsN�+���#/���C&��{'����������ߛ@��r"A�Ƒ���ΐ	���I�c��{����{	w3ND��0� ��!�P��{'���{�������m���'̊��C(��0�p��#�˦:��fvFĬ7#d��"~T�x��<
���^xf�Zm�A��	���m<ì�w��*�Ea� ��u^��P5^V��Z�e�W�E����Gr�.�#D��W��V㏊1B4A�l{HAP5�@|&|<��t�}��Q!:CDfpLR+f��DDn��L����Q#03!r	����2 De�D�2��VZ�R��LH���ѕ��RJ���"�[ʚ�@�1Ɯ�����>:���!�z�Z�d{����^��������kv[�@L�i^`��.� �~7,���3���u[�0L�i^��J���(��~7&�_�����C��m!0�0!R�K�џ��wKG����m���Z�U�-�~q� ��#?�����'�q�m���^����	q�' z�n�H�m+���E��+܇��B��-�m�^���7% �N� �~�H�W�z�3�{�m�+�[��X�;sc��I�[.ҷ��_��
����>���ݿH~ؠ��	�����n�F旓~wn�_���6"�כ���F������s�:�ӯ�t������{O���/'�n�H�(�w �^zݓ� g����������B8��g��}��7*����E"]z�Xz��^��zKb�f�A)�E��ӬΝ� �s�����6������#-���	p�����3`*�tD�go�N�m��s;�O����mߨ�r��.��P�v���o�����F� D�ހ���h��G�c�\��9(n���Q��ߩ�>���>�i��W�������aU�\��b)�o����ܞ�CP��߻o������w}1+҂��֭ TAH ���P�AE4�z�3B.��%(N¿w�q�&ȋ�h�+u+S'�����[$�"��9Ҝy���s��N���E�䮜H��J7 EB����R*�Qސ#��:������s��)َ�x�+t��V4��pK��)�"��m>�!7���=��;W���HB_��^���ɇ� .�z;�TDüMG�1���^��%�{�.w3�iH�+s�!U:�D0K��(�"��>�����sP��\�nD�"
}Un$���&�{�TD�����I��������M�y�a���MBJ�t�*�wE�AE��{����8�����sw׽�ZF�j�DĤe) E��3i����GF�p�s�����7w}��r�iw����q��a&��QC�R{D|)�s���0�{�}�u�z��$�wCd��"~���>�kK�C���Y/<3z���m�w�ft��%��P�?�◕�����s/}Y/ �~���+_��P�?��� �����^ z�?���P'h"��6x�>�!Ӊ�iD��!~5�^h5�H��s{9RUA�l{(� H��s�92���پ��K�b��"���r$�'��,jǒ�r�"���rҪ(""���2Kz?�&y>���RU1!r)�v�,i��I��m��UWL�(��3K�|+-sc��s;91�!QvQ[K�ѕ������C�s�ꪾ "NQ�J:k������ 5u]7\7��>ڀ��0""^Q�%m�Ș�s_T �����l�*cB�+jfI���/��
(�v��I���M&�2Ӕ��xٕ̹ݑ�s_� g�G�駻@���B.�$�������$ z�7wG�/����#p>2����'!�#�w�}P�@O������ t�;�!|��� 
��s7����|�O}S �D���v 2���:�m Z�CQ���7\ �F�_��Sx�� �o�����z���?�8��@oM�M�޸��qґ_������\���w\$�32��l����e������;�/�sw�s#�55�bnd���w��a3����
���������o����8��+!�F�z�mps@��v���@�~e{p��Nb �y�޺Y�q��؍�4��f��>����z�Ğϋ��-���|�S�<End���7�G� ������;�=2�����������h�a(p#C=�6�����O�F��7�7�;�$��x^���7���F�l72��l���o' #o��7DY,�;�$��x^��n����e#��{��#m���g�r�G�ioCN��y'�#�y�E޶KF�,72��l� �9�#��+� ~X�w;0�����m���Áq�Sv�mp�`V�h䝠{?}��Kx３��x^��n���R#O �=OY����Q���ݛB�[��y'1�����.o3�G��72��l�����9�"�z3@�.��;�3ϋ��-�6Rl�IXu#C=�6�	�+���#/��7��r@３��,��?wۼM�y��y:��n�,0���� v�\8��Nb�����:o�#Oę�i��M����P�!��t�;��x^��n�7�Ӗ����|�����P�aL�Ӟ��fvFĬ7�E1d#���(ƃ��ej<X&�u���k�w�U�.���%sԱ\�!��1�29�X"��� biH,�����{�������놋a��~J��W���`qVd�Q��p��_ij�nn�82�(����j�nf�82�(�F>sm�Z��8N�	�����{��2B��M
�ӟ�GB@�w�W/ce�Z��lڑPe��P�w�yM:R�N��0���g\S� �(R��~��>��[8���巹0��'�dFn�?	�Z��~I)��-�����/����?	�q7"_�Z��	�^ݜ�i^�EO������R6��
�IeQ�s#�5�6 M+n��p���1��[t�Q�7&eQ��[#�5�(�p�� ���F���Uz��)���޺Y�qj% W���
�~�^��2�T��r)�������q*	 U����~�F����8��2�L��R)���*�M�}�"	����	��w+��?�e�r�D��2)���-���jp(�	����JW0�z��%R:b�x[k[&%�p�f
�@�`�]�vK9�I�m��D �$�n�Ě`/�Л%��r���Ti� ���%j���Co���Y�AGLoC��H��v,������x�z��tĄ�6S\`$p�bi�Y
����U)1i��Q��mXJ ����	�]�r���D]���݂��R�~�{&�#&���B�~)���/&$v�}���>}�����7��m�V���q�:�w�������^y_G���RT흷�����*����6�1��N�L#R&-����D�$"giѳ�Z\-&������v�w����(�k�n��倫jb��ӹ�i�����F��2��f�?�(��~���j'{!CMl�;�l��)�F>s!CMl�;�L��I �6wG����5�n�h�'!��;򫗱��&��-D��� TA�
jb�
dϞNJ��)S!CMl�[���!�D��2��6�������'�k0�{�/����~2#7;���5�n�rqB���a�?�o?G��8���}B���=gb6�=!CMl����/�!�n��������4�6 M���N�P�ං۟�����a�?�o���4�(J�-rB�����N~��ů��q�?�o���4N���]|B����%��ۆ ����a�?��vG�i�J@%�~�m!�n[8���9���[9�������=�"	���	j��JO�c���[9P����SU�C��|w���Ym8E�8\���R�bQ���m��Pp��V�wfo�Q.	�(����X" T�������0F�i���A�0��P��X�����y�}��;�fo�@�����;)!�n�e4F�y4y+B�[U�{�!.0�"�횵����Uo�@�.��;1�nǬu\��hT��!�\��tEBGĻݲ�Q��p<������� �"�R仝2�`Q�w�񿷞Ӗ��r��Qҟ1�N�L��5�y�k����k3�X�QǺ�!VeL�&c�s�� b5k1�X���:0~���{������wY������ZJ��^�=e�bj�nF���7�>p�g�P��7s�Sw#CKl���u�����ʐy3�~1�q72��ƸY��5y��P{O�7w7�x�rs4HvMj��̡_LM��$i��h��A$�&5Wo��/�f�f��an�^�Drlڐa�y3�~15}7�H��sC�g���C�=]�G���Lő6�S�Mrfo��/�Y��Ti#����5���� �9�NC�=]�G>����#m�[��\>�lPF�!��+1����y������4��s[Fl�[��kI[�K�"�[	�3�����#�<���C���swnˈvct8�Kz0���J�ST?{7E^0���Et䳼�i5�F��[�Ѓ1�@R������j�EC�=]tF>ۻ��"m�[��=�;��%��g�j��7s�Ӭ�f�i��:]�Jz0�w�%K���_��轧���ƻC=yGW�P�=û ����g�2}gm�tuS�Ѓ1��@)Y�����M�,�D)C��&@�d����{.�(�4{)C��&A�d����{*(�Z�Ѓ1���.�����H�J��2�`o2�JF.�����4,�=�[ �%տޓHT0��=�[�%տ�SHD@Ex�-�!��pV2a���=�(OS����1�ǿ��R����3�{�߯��c��D�4"er�2���L�L"r�=K���E�b"i]ѴPDm%�6�L������3�������|�QzￖR�8ޗ�]�*�P�s��Q�'e��9���M�'e��9�N�I�'e��9��E�'e��9��A�'e��9�V�=�'e��9�V�9�'e��9��믑>ā��8� ,����[��eQÃޮK*p��X ��	���޸'EU�ԅ�nK*p����'/,'��*�y��������e)C΁��N~�rqBﭡo����J�Do�R�
�oKx}�9,'��lz��7۶�USR/z��2T�x����;,'��T����9*������-m���[�sX?Jzo*�丨���ӻ�߱Ym8E�z�7�Β)*����>D���;�^�M����-�'�j��q#�z�w�v�-*����>:��7߷a��c���Yz������+�/�ZFc�C����q*Ee�ԙއm�!���3�I����z����u\��(�z�#ʥZTFI��}X�>*��^�G�ԋV/�?�
,�E}�ާ���ۦ��������2J�ss����V�?O�b�y�%��1������?��Wp�s�ΟOƒ����Q�%.��5Z䢎nQ�e.��yZ�b�.���.��9Z�b��.��Ǵ�]ሖ���#�ӢXt�=Z��N`~;�"���.`~�IJ���!��Z8:��)!CC7O�.����~B��8n��mv����!���A����qP�h��A$��O���Ջ�H�ٞ��!��<3=!CC 7L�fyB��8Hn�fs����[q ��.dh��Vk6�ϻ�BB��ϕ�c��24��rK�y-���(C��V�L �?o���!���]�Ѓ1�w@Vҝ���"dh���F(Fl)C��> II��?o���!�[��=�;��&��?o���!�[�\)C��N��ɢ;�;64�s�z򎮮�Jz0�wh%-ݏ�w}�kk_���[�R���]JI�E��wi��BMA�2�`o�KJ(����BE�f/e���$(��Tt�y�J��2�`o"�KJ,���BI��Jz0�7R%%��Š�4,�=�[ �%�ޅ��`vKz0��vK**����@�!�ȇ��YI�E��wH�xZ�R������>��. )�:]?����+���s:Q2�H�\�L*b&5����E�R"hqQ��HZW4-Q[��M&�s����9w�G;����Gi���놌�~��#���SJL�s_:v����cm�:ԏx�-���g &׹8�~d ���j���x-n`�VB�6wn2��~5*�O���En#�.s'�$� ��C-�[��~_���P��-���GBp��p������-��P��-��lG
0��p���-��P�ɭ�{LGJ�K�`��V�[(r��t�[	�X� @�j�ȯ�F�@�B�7]����6��5�x�ש���f�%#��V����	��5n�rqB�-�����o܍��8��m���P��g�P�G��i��V�.��`(��b,'2x�����%�o̍��8�Z�PE�jwf�C��������[E7�/
ݒ����F�kD���|���B���N~�rqBﭺ��(TK�	޺Y�qj���0�*܀�e��nKx}�9,'�ޚ�`��B�$��-����d�"��-�̖��m��\������~�(K��M�}*��������ȫrsB�s+=��7�>�7�gPǋ��$��mW����?n3������j�)����it�L��K��Y:�ێ�:wPV�w�ޛB;���$<�m^�~�V��C���"�۲Eg.	Wx�|���yE���'ن�;�>��������[��6+�P?g-����Y�h��s���Y:N��%�o���s�#�������B���P&��s��7�͉4��YF^�;0kW"/
����r���$��mJ��~�)��aY��D^z��eS/z}I��ی�C��o�S�;8��k���`��Q_���w�e��w�g�yMuz�{�6��YF~�{I�aL'??l��Ϲ�u���V��'c���}ר�et�-rQG���2Ct�<-t1E���Rct�-v1Gw��r@t�cZ���pDK^@��i�,��-{F'p9����vy��]�|��u�p1�{}?����;�M��~Ts1ܨ�_	:bG�yZw���Q,U;�/d舝�f��f��(�F���C��]�#���y�{]��;ō֪D��x$T{G~�z\��;�Ջ�H�َ�*����s�P��H	�:����#v��\� Q�^2t�NrC4�K��H���o�]��p����~2#7��?!CG�(�Z��|�}RF�!��'�]����'���O��r}�̡��Jܢ'd舝�j�Z��V�R����N�����s#�5��9��\�[������R���] v�������aZ����x���9��\�[����ň-e���E`?�@{�}P���nݍ��8��C?���O��;έ�y�R���M v����'����w��v��72_�Tb�4Wꆟr[B�<�N�R���D�ԗ�=ǑO�����߽e��P���C?ͪ܋6t�s�z򎮮�Jz0�whK��h.�~�WB�w�����U��P$��O�2wr��������)e���E�,�⢸|o��}=�&�[Vؖ�9�Ӭ��}Y�)�R���M�� ,����������ݼ{�c��C?�Jܱ�E���Kz0�7	JK��(.�r�3C_��i���i1�~��C1�R��=Û�%A\��m>����ݬ{�㔘C?��܁XRi�R���M�Ԓ /���6�����nҽe�q\̡�f��0,!K)C����,���Vy����nνe�qL̡�f�� ,*��R���-��%!Z���������M��l1�9��Y�;���E>�����Bєݫ��������7"�9Գy�w`J���E>�w��%����^��#�[��e�y�w`J�N�O�ȷ�_��x�6���J����^?�ާC�өd����O�hT6��3B�O��U8V�;�;��d�T�c� ����>"S�Xj B�O�HT@V����>�VY���O��TH4��>E���uE�B��Jͯf���)��'E&�ɇ�����P�A��]%|<��s�_lR ���Y�%/�0л&JD�V�Wf�����]eB�R���Y��w-�)e}fɟo�en��uPB�좷�|�+��7�z8�z���^��;���|��-"�����z��HM]����������nF��؅�K�e&"�}�Q򶏔x�� �\7����:b���	��%��@��Q�"`���^+�:b�#(.Sb��eW2�v��H	p4�k�v3�G·�
Kȅ���߁��� hm�Y+� �F��؇n�
y�����'!��;򫗱2�nd�}���D zB�?�� TA٪� �F��؇nJ��P������S�*<��Lő�[�"2% �N�?� D�����؍��|��5��I��tMحCq(�ſ7�@��_?������:��Lّ���\���=
��pk� o���{�
���}B���;gb6�=	������m�HW�PR{�������h��9��@�@S�n���!ˍ��Vp��0ҕЧ�
�����yg���鍿w[� Q%�9h7�j�|趃��oX.N����۝� ��͎��荿ws�j��Vp	�.>�h7�Y�|趄�w��rq"�7���8�z�nE�����g o����V���Jxw�	x8s#CG�C�-�Ͼ�rq"��������R��9u� ��߻�n��:��@$!`�������nv�[�sX?Ji��BC�J��_��5Y�go����WU�C��|w��g��p��1�)��BA�F��[��-e���{7�m�m��PpwY}8D�!��	F� �^7��;q��'o�����X" T��AV7��i�Ї�&4zݜ�W�����n��Ti� ��ޱ�y�}�H;�>�7���!B�ם]���7��Mu*% D��9�2#�����bB��^wV�+^r��{7�m���H�pw�X�h�� ����� ��$N�I��&��Q���kW"-
}(oQ)"#�F�;��%�O��L8��{7�m��H�xw�X��DZ�0�²BFM5n�A�J~����Lo����6P(��/E��S�2X�'�w��7��,%�^xd�j��߻�n~�-�q�1�����;�-�Gė��8-���,c"Xi���mLgX/<3z���Ԟ���J{G|���^ ����� �������.��.�8Y�p�6���u��bU��ïf���'f�19A��!��s����>8���É@�Dd�$���$&���-\�i?��e@1%L�\B�i&��iX�S"���|+-ssR�AH���ѕ��8�z���Gp��\@D�`KYs}$����.����)%F��8nj}��RO�B��l��b�Q寄q �<����$�z��)����K�N�B��8n��m�I=��]ɜ�G@J����\����� �&$�(ɥ���O���;��g-dh���Fk�"�<�y��OB@�w�W/c!CC7T/v"'��CO
@����!���3q�������S�B��8@n��Δ �;�a'  �����!���\��I��t�nB���Gp�p����~2#7;���q��j���y�QH�[���3����A����7T@H�����\�9�yp7T���-��$��5���z�%
J��pG ��{��(�h��24�sct8�Kj0���/�P��1���o��!" �(J�24�As##����HT,x�p'1��o��"A��ܭ24ās�u����HTxT�=�O�{3ɭ*	 ��n���!�[�\)C&�f�d���b����	o�����P����	zw lh�Fn�wtuU�P���9��S����Z�Ǡx	o���U��P$ �}ׇ��������)e��޴��6RJ�^�rN}�Ya[&%��]��PS�5�ě�
�A�EJ��sPΩ��=3�%@%��e��"M�ճ��
)�n�A9����0N��w�J��2�`ro�Ov���R��
��3�8% D�]J*�V�P�	���R�ܐ��S��{��FR���A	iXJj0���Y�A�AJ��s*�{����tw!(*��R�L�]k���0�R��
�޳Ÿ+:"�]���E>�w�Y�C�#���9�a�Pġ_�|wH�xRy^#�#��74(�T����;mُ�B��R����F����k����+�����.��N�_ш��Eˤ"f2Q3��YZ�{��JJ�{�A��J\.B�%Tbr�.�ҕ��v)�P���˩��*k���d29c����Xڅs���9�v�r��N�]H��oι�oq���(~���gmg~k�n���]w��-����}��Wg��nT��.�����Q��o�T�d/��������� G#���CCCwN:� hm�Y�94�1t�3�	�ޑ_������p����*([1��8�n�s�7%`ꔩ�CCC��9� E�R�����G�_#��ę��N)�7\ �䯟�ȍǣ\�����X.Nd���PO��f×S�w�|��j}�'t{��s&Ɠ��T�����X.N��VB=��w�\@���M)�{A����[&rh�c趂۟��\�H뭄z���N��Z�w�Q��Q�*�%"��8�n;8�����Dv�y�#�}w����[-�J@.Co�ȡ!���^�y�ŉ���DE�����JD�$�T��.�CCC�-�Ͼ�rq"��<ѐ��;e �-����58I���3�C~���~�"�{�y�_Nd7�����D�ީ��f��ic�{�����$A(���Z�2)ᖠw��>"�����!�d7�$����X" \������0F�)�ٽ�Ɍ����$(���Ti�`��wt�z�|߆!Ҏ���=O&��6#I�����&�{WZFc��C��{���;�mB�e�w�).0�z�V�FC����=OE��")�����EA�+��J�E���=O+��.")����M�	3���*��ia�{��y�WH
���n�"�Npe��O~�����_�w�;mُU`=��2|'n��忘�e�ɘ΋�4�]w����e�̨c]��2�X�1Ɗ�9�c ���P���b� ι���+8A7?h~���놋a��1��&��8�nj}�?�_��nT�+�CAH7O�.�7~l�K�N�"��8�n����m�8��Eq@�rw�tM �6wG���EqP�h��A����P����X�P�Ջ��=n�5�
�V�P��}n�5%`ꔩȡ ��{�&k @)K�CAd7D���k����8�|wJ��n�@��_?���G�ȡ �[��\>�.%�yR�ٸ�oN�wC�T��>�����31�d��"��8�n�6�%9lU.%�y�5`7ޜ��	�� 4z�Dq���Ⱥr)�Pxϓ�������7D@E���CAt7B1��R΀��=O�F�͆7'���"A��2�v��ޭ�y�j��#��x���v�����n��PI ���]"�b�n��:]`�p)'�a�'Z#�fÛS�vsUס"	��w&v(�w�'��������{�(�MC��A��U��P$ �N�skk_���[�R��y�a7ij����-�j	zGS�,�D)C	��<A��F� ��ݶK�J�ޱ��"M��2��0yϓ�wCH�����Ti� ��w(E�k)C	��<�y�i"��w*% D��$�f+e(���j�6!M���n3�FR@�0JB�R�2�y*6��*����6RLD��D�[�P���=O�&�]DZ���&ꊄ���!�����[$G�{�M�{��j���8�K���(OS�ɱ��sT�w�;mُ� z��>�L݉��Z�+~�J+>��N�L#R&-����D�$"giѳ�Z\-&��ME�Vbj��������q7���V7V����qamc�US����q�
;��z}��㪪�6�\���� �j=+�zw���ɟ�@T���	�H�&������AR/�޽�HT�&����. �� F�04�vPI� �yV�x$�Cj�UT@)�ceG�14av+PA� ��U�h$�Cb��S �[uFB04�u�5���'qRJ�w?�x
�K(e�����5\��9��	���\�}�R0xs���xʭ��5����������L������b,'�ޛV0x���bj�[d�� Gb�1�n+����ŉa����e{�
 �0� ����b8�vp:��ŉ!����ey�	����Q	hhB鶄i{&)����n""B5��%Aa$��	��&�5��`�6.��ahj�S��RɰN��߭�9���a�
i �l���'yd"��٬6�"e�{���4}wC�O8�JH$EP�>"����&i�����h�pK���d�#i����R���%�+S��X�H�7{7vJ�<f	\i��rݐz��	i2�&��J���$1B+m�!R�����T�@o�nly�XiW"%
�Pz�Ji���&�B��'�(a��Q��0t��-,+��Л��~��'b�DpeF_����߼e?�wxe>_���-��d,cM�t^���ﺫ=ܯ�(ceF�2�X�1Ś�1Vḏ��H�ŀb%�0�8�q7���hG�s���Ɛ����[���vd8��?7�>pT�Ɛ�:{� >0���Ӻ�<����ܺ9������R����~:I��{�r@#����9��� rm`d2B?7Z�~��b K�<+A<2�����;�:+�ȱ2�#S������R I���A42�����z+� ȭ:##���!��E�j��ǔ���y<��%����x�3~���K;8GF(4�s�5����G!!� zK��1+����xʭ��5�'���������L�����?�T�ג��2T�`{[����J�p�!����Yo3��Y�_����]�P���j�&Թ�U�VA  #_ &#M��ň�i|�Ņ:/���j$D�z�+@�Fed@���[��P5����P�W����P��rIP`h����W�P�����6���*v����y#��a�苌�O���5T)C�7�א�P�V���'yd"5���}ႮnaJ*p��Y�3j����R7��#�DR��,�D)C�7��mPs�V���h�pK���E���jJ_cY�f"����#/�K"�BJ��2T��{��m����:7vJ��f	I*�V�P��mm� P��V��J���$1� 	iXJ*pн-�jҪ��(:� ��
f���޻�lA�f ��M��"#�(!�����[��޻Ԭ��ƑV�&�_g�A�z��(O*s�K�q��s�����(�*3����Z���J�����>��9�J�}���B ����i�UE5��[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://c1tlhuywgfmg7"
path="res://.godot/imported/outp.png-8087ac0d633aa39a3bacf30106466c8c.ctex"
metadata={
"vram_texture": false
}
 �e�V���@U)��[remap]

path="res://.godot/exported/133200997/export-2fea4c23ecd46349759679c08410c386-measure_mode_button_group.res"
i�D��O��f+[remap]

path="res://.godot/exported/133200997/export-4a24720ee5e787dbe30abc634fa3679d-Main.scn"
i�y��}j��>B�[remap]

path="res://.godot/exported/133200997/export-c8e30baf94148b25e4bac2b4fd4315c5-Token.scn"
��g�I�g�u����[remap]

path="res://.godot/exported/133200997/export-6b436129bf1eaed15c30d7527c74f0ea-token_builder.scn"
��C��[remap]

path="res://.godot/exported/133200997/export-7cf3fd67ad9f55210191d77b582b8209-default_env.res"
�U<��s�PNG

   IHDR   @   @   �iq�   sRGB ���  0IDATx��}pTU����L����W�$�@HA�%"fa��Yw�)��A��Egةf���X�g˱��tQ���Eq�!�|K�@BHH:�t>�;�����1!ݝn�A�_UWw����{λ��sϽO�q汤��X,�q�z�<�q{cG.;��]�_�`9s��|o���:��1�E�V� ~=�	��ݮ����g[N�u�5$M��NI��-
�"(U*��@��"oqdYF�y�x�N�e�2���s����KҦ`L��Z)=,�Z}"
�A�n{�A@%$��R���F@�$m������[��H���"�VoD��v����Kw�d��v	�D�$>	�J��;�<�()P�� �F��
�< �R����&�կ��� ����������%�u̚VLNfڠus2�̚VL�~�>���mOMJ���J'R��������X����׬X�Ϲ虾��6Pq������j���S?�1@gL���±����(�2A�l��h��õm��Nb�l_�U���+����_����p�)9&&e)�0 �2{��������1���@LG�A��+���d�W|x�2-����Fk7�2x��y,_�_��}z��rzy��%n�-]l����L��;
�s���:��1�sL0�ڳ���X����m_]���BJ��im�  �d��I��Pq���N'�����lYz7�����}1�sL��v�UIX���<��Ó3���}���nvk)[����+bj�[���k�������cݮ��4t:= $h�4w:qz|A��٧�XSt�zn{�&��õmQ���+�^�j�*��S��e���o�V,	��q=Y�)hԪ��F5~����h�4 *�T�o��R���z�o)��W�]�Sm銺#�Qm�]�c�����v��JO��?D��B v|z�կ��܈�'�z6?[� ���p�X<-���o%�32����Ρz�>��5�BYX2���ʦ�b��>ǣ������SI,�6���|���iXYQ���U�҅e�9ma��:d`�iO����{��|��~����!+��Ϧ�u�n��7���t>�l捊Z�7�nвta�Z���Ae:��F���g�.~����_y^���K�5��.2�Zt*�{ܔ���G��6�Y����|%�M	���NPV.]��P���3�8g���COTy�� ����AP({�>�"/��g�0��<^��K���V����ϫ�zG�3K��k���t����)�������6���a�5��62Mq����oeJ�R�4�q�%|�� ������z���ä�>���0�T,��ǩ�����"lݰ���<��fT����IrX>� � ��K��q�}4���ʋo�dJ��م�X�sؘ]hfJ�����Ŧ�A�Gm߽�g����YG��X0u$�Y�u*jZl|p������*�Jd~qcR�����λ�.�
�r�4���zپ;��AD�eЪU��R�:��I���@�.��&3}l
o�坃7��ZX��O�� 2v����3��O���j�t	�W�0�n5����#è����%?}����`9۶n���7"!�uf��A�l܈�>��[�2��r��b�O�������gg�E��PyX�Q2-7���ʕ������p��+���~f��;����T	�*�(+q@���f��ϫ����ѓ���a��U�\.��&��}�=dd'�p�l�e@y��
r�����zDA@����9�:��8�Y,�����=�l�֮��F|kM�R��GJK��*�V_k+��P�,N.�9��K~~~�HYY��O��k���Q�����|rss�����1��ILN��~�YDV��-s�lfB֬Y�#.�=�>���G\k֬fB�f3��?��k~���f�IR�lS'�m>²9y���+ �v��y��M;NlF���A���w���w�b���Л�j�d��#T��b���e��[l<��(Z�D�NMC���k|Zi�������Ɗl��@�1��v��Щ�!曣�n��S������<@̠7�w�4X�D<A`�ԑ�ML����jw���c��8��ES��X��������ƤS�~�׾�%n�@��( Zm\�raҩ���x��_���n�n���2&d(�6�,8^o�TcG���3���emv7m6g.w��W�e
�h���|��Wy��~���̽�!c� �ݟO�)|�6#?�%�,O֫9y������w��{r�2e��7Dl �ׇB�2�@���ĬD4J)�&�$
�HԲ��
/�߹�m��<JF'!�>���S��PJ"V5!�A�(��F>SD�ۻ�$�B/>lΞ�.Ϭ�?p�l6h�D��+v�l�+v$Q�B0ūz����aԩh�|9�p����cƄ,��=Z�����������Dc��,P��� $ƩЩ�]��o+�F$p�|uM���8R��L�0�@e'���M�]^��jt*:��)^�N�@�V`�*�js�up��X�n���tt{�t:�����\�]>�n/W�\|q.x��0���D-���T��7G5jzi���[��4�r���Ij������p�=a�G�5���ͺ��S���/��#�B�EA�s�)HO`���U�/QM���cdz
�,�!�(���g�m+<R��?�-`�4^}�#>�<��mp��Op{�,[<��iz^�s�cü-�;���쾱d����xk瞨eH)��x@���h�ɪZNU_��cxx�hƤ�cwzi�p]��Q��cbɽcx��t�����M|�����x�=S�N���
Ͽ�Ee3HL�����gg,���NecG�S_ѠQJf(�Jd�4R�j��6�|�6��s<Q��N0&Ge
��Ʌ��,ᮢ$I�痹�j���Nc���'�N�n�=>|~�G��2�)�D�R U���&ՠ!#1���S�D��Ǘ'��ೃT��E�7��F��(?�����s��F��pC�Z�:�m�p�l-'�j9QU��:��a3@0�*%�#�)&�q�i�H��1�'��vv���q8]t�4����j��t-}IـxY�����C}c��-�"?Z�o�8�4Ⱦ���J]/�v�g���Cȷ2]�.�Ǣ ��Ս�{0
�>/^W7�_�����mV铲�
i���FR��$>��}^��dُ�۵�����%��*C�'�x�d9��v�ߏ � ���ۣ�Wg=N�n�~������/�}�_��M��[���uR�N���(E�	� ������z��~���.m9w����c����
�?���{�    IEND�B`�N_'�S��/^   ��R1\Ctf)   res://misc/measure_mode_button_group.tres��h�l}�x   res://scenes/Main.tscn٘��8�sZ   res://scenes/Token.tscnJz��_&   res://scenes/token_builder.tscn� a�Xg�i   res://default_env.tres��Ng+�NC   res://icon.png�V�n�\   res://outp.png�ECFG      application/config/name      	   LancerMap      application/run/main_scene          res://scenes/Main.tscn     application/config/features   "         4.0     application/boot_splash/bg_color      q�>q�>q�>  �?   application/config/icon         res://icon.png     autoload/NetworkingSingleton8      0   *res://scenes/networking/networking_singleton.gd   autoload/Grid          *res://scenes/grid.gd      connections/socket_url$         wss://lancermap.fly.dev:443    connections/maps_url,      !   https://lancermap.fly.dev:80/map/      connections/test_socket_url         ws://localhost:8080    connections/test_maps_url$         http://localhost:8081/map/     connections/in_testing             dotnet/project/assembly_name      	   LancerMap      input/camera�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         pressed           double_click          script         input/scroll_up�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         pressed           double_click          script         input/scroll_down�              deadzone      ?      events              InputEventMouseButton         resource_local_to_scene           resource_name             device         	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          button_mask           position              global_position               factor       �?   button_index         pressed           double_click          script         input/show_grid_help�              deadzone      ?      events              InputEventKey         resource_local_to_scene           resource_name             device     ����	   window_id             alt_pressed           shift_pressed             ctrl_pressed          meta_pressed          pressed           keycode           physical_keycode    @ 	   key_label             unicode           echo          script      #   rendering/renderer/rendering_method         gl_compatibility)   rendering/environment/default_environment          res://default_env.tres     shader_globals/grid_colorD               type      vec4      value        �?  �?  �?  �?�9��A��