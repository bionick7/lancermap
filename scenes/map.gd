class_name MapSprite
extends Sprite2D

var http_request: HTTPRequest
var url_base: String

var is_requesting := false

func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	if ProjectSettings.get("connections/in_testing"):
		url_base = ProjectSettings.get("connections/test_maps_url")
	else:
		url_base = ProjectSettings.get("connections/maps_url")

func set_map(room_name: String, image: Image) -> void:
	if is_requesting:
		await http_request.request_completed
	texture = ImageTexture.create_from_image(image)
	if room_name == "INVALID":
		return
	var error := http_request.request_raw(
		url_base + room_name, 
		PackedStringArray(), 
		HTTPClient.METHOD_POST, 
		image.save_png_to_buffer()
	)
	if error != OK:
		push_error("Error occured tyinging to upload map: %s" % error_string(error))
		return
	is_requesting = true
	var res : Array = await http_request.request_completed
	is_requesting = false
	var result: int = res[0]
	var return_code: int = res[1]
	var headers: PackedStringArray = res[2]
	var content: PackedByteArray = res[3]
	if result != OK:
		push_error("Error occured when uploading map: %s" % error_string(result))
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

func download_map(room_name: String) -> void:
	if is_requesting:
		await http_request.request_completed
	if room_name == "INVALID":
		return
	var error := http_request.request_raw(
		url_base + room_name, 
		PackedStringArray(), 
		HTTPClient.METHOD_GET
	)
	if error != OK:
		push_error("Error occured when uploading map: %s" % error_string(error))
	is_requesting = true
	var res : Array = await http_request.request_completed
	is_requesting = false
	var result: int = res[0]
	var return_code: int = res[1]
	var headers: PackedStringArray = res[2]
	var content: PackedByteArray = res[3]
	if result != OK:
		push_error("Error occured when uploading map: %s" % error_string(result))
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
	var image := Image.new()
	error = image.load_png_from_buffer(content)
	if error != OK:
		push_error("Error occured when uploading map: %s" % error_string(result))
		return
	texture = ImageTexture.create_from_image(image)
