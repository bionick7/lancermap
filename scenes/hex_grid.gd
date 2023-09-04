class_name HexMap
extends Node2D

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

var offset := Vector2.ZERO
var tile_size := Vector2(64, 64)
var is_horizontal := false

@onready var default_font = Control.new().get_theme_default_font()

signal grid_changed()
	
func _draw():
	for x in range(-5, 5):
		for y in range(-5, 5):
			var tile_pos := eval_tile(Vector2i(x, y))
			draw_polyline(_make_hex(tile_pos, tile_size), Color.RED, -1)
			
	for i in range(6):
		var tile_pos := eval_tile(get_neighbour(Vector2i.ZERO, i))
		var tile_pos2 := eval_tile(get_neighbour(Vector2i(2, 3), i))
		var tile_pos3 := eval_tile(get_neighbour(Vector2i(7, -2), i))
		draw_circle(tile_pos, 5, Color.RED)
		draw_circle(tile_pos2, 5, Color.RED)
		draw_circle(tile_pos3, 5, Color.RED)

func get_tile_estimate(inp: Vector2) -> Vector2i:
	var dx = (inp - offset).x / tile_size.x
	var dy = (inp - offset).y / tile_size.y
	if is_horizontal:
		var tmp = dx
		dx = dy
		dy = tmp
	var x0: int = dx * 1.3333
	var y0: int = dy if posmod(x0, 2) == 0 else dy - 0.5
	if is_horizontal:
		var tmp = x0
		x0 = y0
		y0 = tmp
	return Vector2i(x0, y0)

func get_tile(inp: Vector2) -> Vector2i:
	var p0 := get_tile_estimate(inp)
	var min_dist_sqr = (eval_tile(p0) - inp).length_squared()
	for c in [p0 + Vector2i(0, 1), p0 + Vector2i(1, 0), p0 + Vector2i(1, 1)]:
		var dist_sqr = (eval_tile(c) - inp).length_squared()
		if dist_sqr < min_dist_sqr:
			p0 = c
			min_dist_sqr = dist_sqr
	return p0
	
func eval_tile(inp: Vector2i) -> Vector2:
	if is_horizontal:
		return Vector2(
			(inp.x + 0.5 if posmod(inp.y, 2) == 1 else inp.x) * tile_size.x + offset.x,
			inp.y * .75 * tile_size.y + offset.y,
		)
	else:
		return Vector2(
			inp.x * .75 * tile_size.x + offset.x,
			(inp.y + 0.5 if posmod(inp.x, 2) == 1 else inp.y) * tile_size.y + offset.y,
		)

var NEIGHBOUR_LOOKUP := PackedInt32Array([
	1,0,  -1,0,  0,1,  0,-1,  -1,-1,  1,-1,  # from % 2 (0, 0)  not horizontal
	1,0,  -1,0,  0,1,  0,-1,  -1,-1,  1,-1,  # from % 2 (0, 1)  not horizontal
	1,0,  -1,0,  0,1,  0,-1,  -1, 1,  1, 1,  # from % 2 (1, 0)  not horizontal
	1,0,  -1,0,  0,1,  0,-1,  -1, 1,  1, 1,  # from % 2 (1, 1)  not horizontal
	1,0,  -1,0,  0,1,  0,-1,  -1,-1, -1, 1,  # from % 2 (0, 0)      horizontal
	1,0,  -1,0,  0,1,  0,-1,   1,-1,  1, 1,  # from % 2 (0, 1)      horizontal
	1,0,  -1,0,  0,1,  0,-1,  -1,-1, -1, 1,  # from % 2 (1, 0)      horizontal
	1,0,  -1,0,  0,1,  0,-1,   1,-1,  1, 1,  # from % 2 (1, 1)      horizontal
])

func get_neighbour(from: Vector2i, neighbour_idx: int) -> Vector2i:
	var index = neighbour_idx + posmod(from.y, 2)*6 + posmod(from.x, 2)*12 + int(is_horizontal)*24
	return from + Vector2i(NEIGHBOUR_LOOKUP[index*2], NEIGHBOUR_LOOKUP[index*2 + 1])

func deserialize(data: Dictionary) -> void:
	offset = data.offset
	tile_size = data.tile_size
	is_horizontal = data.is_horizontal
	queue_redraw()
	
func serialize() -> Dictionary:
	return {
		offset = offset,
		tile_size = tile_size,
		is_horizontal = is_horizontal,
	}
	
func _make_hex(center: Vector2, size: Vector2) -> PackedVector2Array:
	var res: PackedVector2Array
	if is_horizontal:
		res = PackedVector2Array(UNITY_HEXAGON_HORI)
	else:
		res = PackedVector2Array(UNITY_HEXAGON_VERT)
	for i in range(7):
		res[i] = center + (res[i] - Vector2(.5, .5)) * size
	return res

func _on_grid_changed() -> void:
	queue_redraw()
	grid_changed.emit()

func _on_x0_changed(value: float) -> void:
	offset.x = value
	_on_grid_changed()

func _on_y0_changed(value: float) -> void:
	offset.y = value
	_on_grid_changed()

func _on_sizex_changed(value: float) -> void:
	tile_size.x = value
	_on_grid_changed()

func _on_sizey_changed(value: float) -> void:
	tile_size.y = value
	_on_grid_changed()

func _on_horizontal_changed(button_pressed: bool):
	is_horizontal = button_pressed
	_on_grid_changed()
