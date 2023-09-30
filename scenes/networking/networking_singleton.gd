#class_name NetworkingSingleton
extends Node


var room: String = "INVALID"
var tokens: Dictionary = {}
var is_gm := true :
	get: return is_gm
	set(x): 
		is_gm = x
		gm_status_changed.emit(x)

var active_socket = null

@onready var self_name = "%d" % randi()

signal gm_status_changed(new_status)

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
