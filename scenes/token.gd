class_name Token
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
	tile = data.tile_index
	position = Grid.eval_tile(tile)
	queue_redraw()
	
func serialize() -> Dictionary:
	return {
		tile = tile,
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
	var new_index = Grid.get_tile(pos)
	if new_index != tile:
		tile = new_index
		position = Grid.eval_tile(tile)
		return true
	return false

func get_covered_tiles() -> Array[Vector2i]:
	return Grid.get_covered_tiles(tile, size)
