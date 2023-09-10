class_name MapSprite
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
	return OS.get_name() != "Web"
