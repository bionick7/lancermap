class_name Token
extends Node2D

var dragging := false

var uuid: int = -1
var size: int = 1
var tile_index := Vector2i.ZERO

var is_online := false:
	set(x):
		is_online = x
		queue_redraw()

var is_spawned_by_local := true

@onready var sprite: Sprite2D = $Sprite
# Hacky af aproach
@onready var map: HexMap = $"/root/main/HexGrid"
@onready var default_font = Control.new().get_theme_default_font()

signal data_changed(me: Token)
signal request_edit(me: Token)

func _draw():
	draw_string(default_font, Vector2.ZERO, "%d" % uuid)
	draw_circle(Vector2(0, -8), 5, Color.GREEN if is_online else Color.RED)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		var hover = sprite.get_rect().has_point(sprite.to_local(get_global_mouse_position()))
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and hover:
				dragging = true
			else:
				dragging = false
		elif event.button_index == MOUSE_BUTTON_RIGHT and hover:
			request_edit.emit(self)
			get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion and dragging:
		if move_to(get_global_mouse_position()):
			data_changed.emit(self)
	

func deserialize(data: Dictionary) -> void:
	print("Deserialize :", data)
	sprite.transform = data.transf
	size = data.size
	tile_index = data.tile_index
	position = map.eval_tile(tile_index)
	queue_redraw()
	
func serialize() -> Dictionary:
	return {
		tile_index = tile_index,
		size = size,
		transf = sprite.transform
	}
	
func deserialize_image(data: PackedByteArray) -> void:
	var img := Image.new()
	img.load_png_from_buffer(data)
	set_sprite(ImageTexture.create_from_image(img))
	
func serialize_image() -> PackedByteArray:
	return sprite.texture.get_image().save_png_to_buffer()
	
func set_add_transform(transf: Transform2D) -> void:
	sprite.transform = transf
	
func set_sprite(texture: Texture2D) -> void:
	sprite.texture = texture
	
func get_sprite() -> Texture2D:
	return sprite.texture
	
func move_to(pos: Vector2) -> bool:
	var new_index = map.get_tile(pos)
	if new_index != tile_index:
		tile_index = new_index
		position = map.eval_tile(tile_index)
		return true
	return false

func get_covered_tiles() -> Array[Vector2i]:
	return [tile_index]
