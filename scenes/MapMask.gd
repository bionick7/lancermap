extends PointLight2D

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

func _draw():
	_draw_tile_filled(Vector2i.ZERO)
	
func _make_hex(center: Vector2, size: Vector2) -> PackedVector2Array:
	var res: PackedVector2Array
	if Grid.is_horizontal:
		res = PackedVector2Array(UNITY_HEXAGON_HORI)
	else:
		res = PackedVector2Array(UNITY_HEXAGON_VERT)
	for i in range(7):
		res[i] = center + (res[i] - Vector2(.5, .5)) * size
	return res
	
func _draw_tile_filled(tile: Vector2i) -> void:
	draw_colored_polygon(_make_hex(Grid.eval_tile(tile), Grid.tile_size), Color.WHITE)
