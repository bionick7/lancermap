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
var draw_alignment_help := false

@onready var default_font = Control.new().get_theme_default_font()
@onready var map_shadermat: ShaderMaterial = $Map.material

signal grid_changed()

func _ready():
	measure_mode_button_group.pressed.connect(_on_mm_button_pressed)
	_on_fog_item_selected(%Fog.selected)
	_on_grid_changed()
	_on_visible_tiles_changed()

func _input(event: InputEvent):
	if event is InputEventMouseMotion and active_measure_mode != MeasuringMode.NONE:
		_fog_draw_routine()
		queue_redraw()
	
	if event.is_action_pressed("show_grid_help"):
		draw_alignment_help = not draw_alignment_help
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
				tiles = Grid.get_line(from_pos, measure_size, to_pos)
			MeasuringMode.CONE:
				tiles = Grid.get_cone(from_pos, measure_size, to_pos)
			MeasuringMode.BURST:
				tiles = Grid.get_burst(from_pos, measure_size, to_pos)
				
		for tile in tiles:
			_draw_tile(tile, Color.CORNFLOWER_BLUE)

func deserialize(data: Dictionary) -> void:
	Grid.offset = data.offset
	Grid.tile_size = data.tile_size
	Grid.is_horizontal = data.is_horizontal
	Grid.blocking_tiles = data.blocking_tiles
	Grid.fow_effect = data.fow_effect
	%Fog.selected = data.fow_effect
	Grid.on_config_changed.emit(true)
	queue_redraw()
	_setup_shader()
	
func serialize() -> Dictionary:
	return {
		offset = Grid.offset,
		tile_size = Grid.tile_size,
		is_horizontal = Grid.is_horizontal,
		blocking_tiles = Grid.blocking_tiles,
		fow_effect = Grid.fow_effect
	}
	
func handle_mouse_button(event: InputEventMouseButton, token: Token) -> void:
	_fog_draw_routine()
	if event.pressed and active_measure_mode == MeasuringMode.FOG:
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
	
func update_map_visibility() -> void:
	_on_visible_tiles_changed()
	
func _fog_draw_routine() -> void:
	var hovered_tile := _get_hovered_tile()
	if active_measure_mode == MeasuringMode.FOG:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and hovered_tile not in Grid.blocking_tiles:
			Grid.blocking_tiles.append(hovered_tile)
			_on_grid_changed()
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and hovered_tile in Grid.blocking_tiles:
			Grid.blocking_tiles.erase(hovered_tile)
			_on_grid_changed()
	for t in NetworkingSingleton.tokens.values():
		t.visible = t.is_token_visible()
	
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
	Grid.on_config_changed.emit(false)
	_setup_shader()

func _setup_shader() -> void:
	map_shadermat.set_shader_parameter("tile_size", Grid.tile_size)
	map_shadermat.set_shader_parameter("offset", Grid.offset)
	map_shadermat.set_shader_parameter("is_horizontal", Grid.is_horizontal)
	if Grid.fow_effect in [Grid.FOWEffect.HideAll, Grid.FOWEffect.NoSensors] and not NetworkingSingleton.is_gm:
		map_shadermat.set_shader_parameter("fow_color", Color(0, 0, 0, 1.0))
	else:
		map_shadermat.set_shader_parameter("fow_color", Color(0, 0, 0, 0.2))

func _on_visible_tiles_changed() -> void:
	Grid.update_visible_tiles()
	var n_tiles := len(Grid.visible_tiles)
	
	var visible_tiles_as_int_arr := PackedInt32Array()
	visible_tiles_as_int_arr.resize(n_tiles*2)
	for i in range(n_tiles):
		var tile: Vector2i = Grid.visible_tiles[i]
		visible_tiles_as_int_arr[i*2] = tile.x
		visible_tiles_as_int_arr[i*2 + 1] = tile.y
	
	for token in NetworkingSingleton.tokens.values():
		if not token.is_player:
			token.visible = token.is_token_visible()
	
	map_shadermat.set_shader_parameter("visible", visible_tiles_as_int_arr)
	map_shadermat.set_shader_parameter("visible_size", n_tiles)

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

func _on_horizontal_changed(button_pressed: bool) -> void:
	Grid.is_horizontal = button_pressed
	_on_grid_changed()

func _on_mm_button_pressed(button: Button) -> void:
	active_measure_mode = button.get_meta("mode", 0)

func _on_fog_item_selected(index: Grid.FOWEffect) -> void:
	Grid.fow_effect = index
	_on_grid_changed()
