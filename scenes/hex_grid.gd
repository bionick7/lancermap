class_name HexMap
extends Node2D

enum MeasuringMode {
	NONE,
	DISTANCE,
	LINE,
	CONE,
	BURST,
	FOG,
}

var UNITY_HEXAGON_VERT := PackedVector2Array([
	Vector2(.25, 0),
	Vector2(.75, 0),
	Vector2(1, .5),
	Vector2(.75, 1),
	Vector2(.25, 1),
	Vector2(0, .5),
	Vector2(.25, 0),
])

var UNITY_HEXAGON_HORI := PackedVector2Array([
	Vector2(0, .25),
	Vector2(0, .75),
	Vector2(.5, 1),
	Vector2(1, .75),
	Vector2(1, .25),
	Vector2(.5, 0),
	Vector2(0, .25),
])

@export var measure_mode_button_group: ButtonGroup

var active_measure_mode: MeasuringMode
var from_pos = null
var measure_size := 1 # temporary
var draw_alignment_help := true

@onready var default_font = Control.new().get_theme_default_font()
@onready var map_shadermat: ShaderMaterial = $Map.material

signal grid_changed()

func _ready():
	measure_mode_button_group.pressed.connect(_on_mm_button_pressed)
	_on_grid_changed()
	_on_visible_tiles_changed()

func _input(event: InputEvent):
	if event is InputEventMouseMotion and active_measure_mode != MeasuringMode.NONE:
		var hovered_tile := _get_hovered_tile()
		if active_measure_mode == MeasuringMode.FOG:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovered_tile not in Grid.blocking_tiles:
				Grid.blocking_tiles.append(hovered_tile)
			elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and hovered_tile in Grid.blocking_tiles:
				Grid.blocking_tiles.erase(hovered_tile)
			
		queue_redraw()

func _draw():
	# Draws centering cross
	if draw_alignment_help:
		_draw_tile(Vector2i.ZERO)
		for direction in range(6):
			var running := Grid.get_neighbour(Vector2i.ZERO, direction)
			for dist in range(20):
				draw_string(default_font, Grid.eval_tile(running), "%d" % direction, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color.RED)
				_draw_tile(running)
				running = Grid.get_neighbour(running, direction)
			_draw_tile(running)
				
	if active_measure_mode == MeasuringMode.FOG:
		for blocking in Grid.blocking_tiles:
			_draw_tile_filled(blocking)
				
	# Draws measurements
	if from_pos != null:
		var tiles := []
		var to_pos := _get_hovered_tile()
			
		match active_measure_mode:
			MeasuringMode.NONE:
				pass
			MeasuringMode.DISTANCE:
				tiles = Grid.get_shortest_path(from_pos, measure_size, to_pos)
				var i := len(tiles)
				for t in tiles:
					i -= 1
					draw_string(default_font, Grid.eval_tile(t), "%d" % i, HORIZONTAL_ALIGNMENT_CENTER, -1, 16, Color.CORNFLOWER_BLUE)
			MeasuringMode.LINE:
				push_error("Line tool not implemented")
			MeasuringMode.CONE:
				push_error("Cone tool not implemented")
			MeasuringMode.BURST:
				tiles = Grid.get_burst(from_pos, measure_size, to_pos)
				
		for tile in tiles:
			_draw_tile(tile, Color.CORNFLOWER_BLUE)
				

func deserialize(data: Dictionary) -> void:
	Grid.offset = data.offset
	Grid.tile_size = data.tile_size
	Grid.is_horizontal = data.is_horizontal
	Grid.blocking_tiles = data.blocking_tiles
	queue_redraw()
	
func serialize() -> Dictionary:
	return {
		offset = Grid.offset,
		tile_size = Grid.tile_size,
		is_horizontal = Grid.is_horizontal,
		blocking_tiles = Grid.blocking_tiles,
	}
	
func handle_mouse_button(event: InputEventMouseButton, token: Token) -> void:
	if event.pressed and active_measure_mode == MeasuringMode.FOG:
		var hovered_tile := _get_hovered_tile()
		if event.button_index == MOUSE_BUTTON_LEFT and hovered_tile not in Grid.blocking_tiles:
			Grid.blocking_tiles.append(hovered_tile)
		elif event.button_index == MOUSE_BUTTON_RIGHT and hovered_tile in Grid.blocking_tiles:
			Grid.blocking_tiles.erase(hovered_tile)
		return
	if event.pressed:
		if token == null:
			measure_size = 1
			from_pos = _get_hovered_tile()
		else:
			measure_size = token.size
			from_pos = token.tile
	else:
		from_pos = null
	
func _make_hex(center: Vector2, size: Vector2) -> PackedVector2Array:
	var res: PackedVector2Array
	if Grid.is_horizontal:
		res = PackedVector2Array(UNITY_HEXAGON_HORI)
	else:
		res = PackedVector2Array(UNITY_HEXAGON_VERT)
	for i in range(7):
		res[i] = center + (res[i] - Vector2(.5, .5)) * size
	return res

func _draw_tile(tile: Vector2i, color: Color=Color.RED) -> void:
	draw_polyline(_make_hex(Grid.eval_tile(tile), Grid.tile_size), color)

func _draw_tile_filled(tile: Vector2i, color: Color=Color.RED) -> void:
	draw_colored_polygon(_make_hex(Grid.eval_tile(tile), Grid.tile_size), color)

func _get_hovered_tile() -> Vector2i:
	return Grid.get_tile(get_global_mouse_position())
	
func _on_grid_changed() -> void:
	queue_redraw()
	grid_changed.emit()
	map_shadermat.set_shader_parameter("tile_size", Grid.tile_size)
	map_shadermat.set_shader_parameter("offset", Grid.offset)
	map_shadermat.set_shader_parameter("is_horizontal", Grid.is_horizontal)

func _on_visible_tiles_changed() -> void:
	var visible_tiles := []
	var visible_tiles_as_int_arr := PackedInt32Array()
	for p in NetworkingSingleton.get_player_tokens():
		for tile in Grid.get_sensors(p.tile, p.size, p.sensor_range):
			if tile not in visible_tiles:
				visible_tiles.append(tile)
				visible_tiles_as_int_arr.append(tile.x)
				visible_tiles_as_int_arr.append(tile.y)
	
	map_shadermat.set_shader_parameter("visible", visible_tiles_as_int_arr)
	map_shadermat.set_shader_parameter("visible_size", len(visible_tiles))

func _on_x0_changed(value: float) -> void:
	Grid.offset.x = value
	_on_grid_changed()

func _on_y0_changed(value: float) -> void:
	Grid.offset.y = value
	_on_grid_changed()

func _on_sizex_changed(value: float) -> void:
	Grid.tile_size.x = value
	_on_grid_changed()

func _on_sizey_changed(value: float) -> void:
	Grid.tile_size.y = value
	_on_grid_changed()

func _on_horizontal_changed(button_pressed: bool):
	Grid.is_horizontal = button_pressed
	_on_grid_changed()

func _on_mm_button_pressed(button: Button):
	active_measure_mode = button.get_meta("mode", 0)
