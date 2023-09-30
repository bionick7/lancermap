extends Node

@onready var message_container: VBoxContainer = $Window/V/ScrollContainer/V
@onready var window: Window = $Window

var log_string := ""

func _ready():
	window.hide()
	log_msg("First message")

func _input(event: InputEvent):
	if event.is_action_pressed("show_debug"):
		if window.visible:
			window.hide()
		else:
			window.popup_centered()

func log_msg(msg: String) -> void:
	log_string += msg + "\n"
	var label := Label.new()
	label.text = msg
	message_container.add_child(label)

func log_error(msg: String) -> void:
	push_error(msg)
	log_string += msg + "\n"
	var label := Label.new()
	label.text = msg
	label.modulate = Color.RED
	message_container.add_child(label)

func _on_window_close_requested():
	window.hide()

func _on_save_pressed():
	JavaScriptBridge.download_buffer(log_string.to_utf8_buffer(), "log.txt")
