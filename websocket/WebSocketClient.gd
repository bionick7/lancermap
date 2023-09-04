extends Node
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
}

enum ResponseActionCode {
	INVALID = 0,
	SEND_ERROR = 1,  # followed by string in utf-8
	SEND_DATA = 2,  # followed by token, then 0 or 1 for data or img, then bytes
	SEND_TOKEN_LIST = 3,  # followed by array of tokens (little-endian u64)
	SEND_TOKEN_KILL = 4,  # followed by token id
	SEND_REG_RESPONSE = 5,  # followed by single byte representing boolean (0 or 1) to confirm REG_AS_GM or REG_AS_PLAYER
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

func send(roomname: String, action: RequestActionCode, token_id: int=1, payload: Variant={}) -> Error:
	if roomname == "INVALID":
		push_error("Called send without opening or joining a room")
		return FAILED
	if socket.get_ready_state() != WebSocketPeer.STATE_OPEN:
		return FAILED
	var buffer := _encode_msg(roomname, action, token_id, payload)
	return socket.send(buffer)

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
	buffer.append_array(roomname_buffer)
	var pos := roomname_buffer.size()
	buffer.resize(pos + 10)
	buffer.encode_u8(pos, 0)
	buffer.encode_u64(pos+1, token_id)
	buffer.encode_u8(pos+9, action)
	buffer.append_array(payload_buffer)
	return buffer
