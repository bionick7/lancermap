class_name WSSImageHandler
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
