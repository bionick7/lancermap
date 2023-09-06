class_name HttpImageHandler
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
