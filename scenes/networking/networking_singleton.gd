#class_name NetworkingSingleton
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