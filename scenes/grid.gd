extends Node

enum Size {
	S1 = 1,
	S2 = 2,
	S3 = 3,
	S4 = 4,
}

enum FOWEffect {
	ShowAll,
	HideTokens,
	HideAll,
	NoSensors,
}

#Drawn
var always_visible_tiles: Array = []
var blocking_tiles: Array = []
# Updated
var visible_tiles: Array = []

var NEIGHBOUR_LOOKUP := PackedInt32Array([
	0,-1,  1,-1,  1,0,  0,1, -1,0, -1,-1,   # from % 2 (0, 0)  not horizontal
	0,-1,  1,-1,  1,0,  0,1, -1,0, -1,-1,   # from % 2 (0, 1)  not horizontal
	0,-1,  1, 0,  1,1,  0,1, -1,1, -1, 0,   # from % 2 (1, 0)  not horizontal
	0,-1,  1, 0,  1,1,  0,1, -1,1, -1, 0,   # from % 2 (1, 1)  not horizontal
	0,-1,  1, 0,  0,1, -1,1, -1,0, -1,-1,   # from % 2 (0, 0)      horizontal
	1,-1,  1, 0,  1,1,  0,1, -1,0,  0,-1,   # from % 2 (0, 1)      horizontal
	0,-1,  1, 0,  0,1, -1,1, -1,0, -1,-1,   # from % 2 (1, 0)      horizontal
	1,-1,  1, 0,  1,1,  0,1, -1,0,  0,-1,   # from % 2 (1, 1)      horizontal
])

var offset := Vector2.ZERO
var tile_size := Vector2(75, 89)
var is_horizontal := true
var fow_effect := FOWEffect.ShowAll

signal on_config_changed(from_remote: bool)

func _get_tile_estimate(inp: Vector2) -> Vector2i:
	var dx = (inp - offset).x / tile_size.x
	var dy = (inp - offset).y / tile_size.y
	if is_horizontal:
		var tmp = dx
		dx = dy
		dy = tmp
	dx += 0.25 * sign(dx)
	dy += 0.5 * sign(dy)
	var x0: int = dx * 1.3333
	var y0: int = dy if posmod(x0, 2) == 0 else dy - 0.5
	if is_horizontal:
		var tmp = x0
		x0 = y0
		y0 = tmp
	return Vector2i(x0, y0)

func get_tile(inp: Vector2) -> Vector2i:
	var p0 := _get_tile_estimate(inp)
	var min_dist_sqr = (eval_tile(p0) - inp).length_squared()
	#for c in [p0 + Vector2i(0, 1), p0 + Vector2i(1, 0), p0 + Vector2i(1, 1)]:
	for c in range(6).map(func(x): return get_neighbour(p0, x)):
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

func get_neighbour(from: Vector2i, neighbour_idx: int) -> Vector2i:
	var index = neighbour_idx + posmod(from.y, 2)*6 + posmod(from.x, 2)*12 + int(is_horizontal)*24
	return from + Vector2i(NEIGHBOUR_LOOKUP[index*2], NEIGHBOUR_LOOKUP[index*2 + 1])

func get_covered_tiles(center: Vector2i, size: Size) -> Array[Vector2i]:
	var res: Array[Vector2i] = [center]
	if size in [2, 4]:
		if is_horizontal:
			res.append(get_neighbour(center, 1))
			res.append(get_neighbour(center, 2))
		else:
			res.append(get_neighbour(center, 2))
			res.append(get_neighbour(center, 3))
	if size in [3, 4]:
		for t in res.duplicate():
			for i in range(6):
				var neighbour := get_neighbour(t, i)
				if neighbour not in res:
					res.append(neighbour)
	return res

func _floodfill(cache: Dictionary, in_domain: Callable, eval: Callable, end: Vector2i=Vector2i(1e10, 0)) -> Dictionary:
	var q :Array = cache.keys()
	while len(q) > 0:
		var current: Vector2i = q.pop_front()
		if current == end:
			return cache
		for i in range(6):
			var neighbour := get_neighbour(current, i)
			if in_domain.call(current, neighbour, cache[current]) and neighbour not in cache:
				cache[neighbour] = eval.call(current, neighbour, cache[current])
				q.append(neighbour)
	return cache
"""
func _get_closest(candidates: Array[Vector2i], to: Vector2i) -> Vector2i:
	var dest_pos := eval_tile(to)
	var best := candidates[0]
	var best_dist_sqr := eval_tile(candidates[0]).distance_squared_to(dest_pos)
	for candidate in candidates.slice(1):
		var dist_sqr := eval_tile(candidate).distance_squared_to(dest_pos)
		if dist_sqr < best_dist_sqr:
			best = candidate
			best_dist_sqr = dist_sqr
	assert(best in candidates)
	return best

func get_line(from: Vector2i, size: Size, to: Vector2i) -> Array[Vector2i]:
	var res : Array[Vector2i] = []
	var current = _get_closest(get_covered_tiles(from, size), to)
	while current != to:
		var neighbours : Array[Vector2i] = []
		for i in range(6): neighbours.append(get_neighbour(current, i))
		current = _get_closest(neighbours, to)
		res.append(current)
	return res
"""

func _does_tile_intersect_line(line_a: Vector2, line_b: Vector2, tile: Vector2i) -> bool:
	var tile_pos := eval_tile(tile)
	#if tile_pos.x < min(line_a.x, line_b.x) or tile_pos.x > max(line_a.x, line_b.x):
	#	return false
	#if tile_pos.y < min(line_a.y, line_b.y) or tile_pos.y > max(line_a.y, line_b.y):
	#	return false
	var ba := line_b - line_a
	var pa := tile_pos - line_a
	var h := clampf(pa.dot(ba) / ba.dot(ba), 0., 1.)
	var sdf := (pa - h * ba).length()
	return sdf < tile_size[tile_size.max_axis_index()] * .4

func has_line_of_sight(from: Vector2i, to: Vector2i) -> bool:
	if is_tile_occupied(to):
		return false
	var line_a := eval_tile(from)
	var line_b := eval_tile(to)
	for tile in blocking_tiles:
		if _does_tile_intersect_line(line_a, line_b, tile):
			return false
	
	return true

func get_line(from: Vector2i, size: Size, to: Vector2i) -> Array[Vector2i]:
	Logger.log_error("Cone tool not implemented")
	return []
	
func get_cone(from: Vector2i, size: Size, to: Vector2i) -> Array[Vector2i]:
	Logger.log_error("Cone tool not implemented")
	return []

func get_distance(from: Vector2i, size: Size, to: Vector2i) -> int:
	var bounds := Rect2i(
		mini(from.x, to.x),
		mini(from.y, to.y),
		absi(from.x - to.x)+1,
		absi(from.y - to.y)+1,
	)
	
	var cache = {}
	for p in get_covered_tiles(from, size):
		cache[p] = 0
	
	_floodfill(cache,
		func(parent, child, parent_cache): return bounds.has_point(child),
		func(parent, child, parent_cache): return parent_cache + 1,
	)
	return cache[to]
	
func _fill_distance_cache(bounds: Rect2i, current: Vector2i, cache: Dictionary) -> void:
	var neighbours = range(6).map(
		func(x): return get_neighbour(current, x)
	).filter(
		func(x): return bounds.has_point(x) and x not in cache
	)
	for neighbour in neighbours:
		cache[neighbour] = cache[current] + 1
	for neighbour in neighbours:
		_fill_distance_cache(bounds, neighbour, cache)


func get_shortest_path(from: Vector2i, size: Size, to: Vector2i) -> Array[Vector2i]:
	#var t0 = Time.get_ticks_usec()
	
	var bounds := Rect2i(
		mini(from.x, to.x),
		mini(from.y, to.y),
		absi(from.x - to.x)+1,
		absi(from.y - to.y)+1,
	)
	
	var cache = {}
	for p in get_covered_tiles(from, size):
		cache[p] = null
		
	_floodfill(cache,
		func(parent, child, parent_cache): return bounds.has_point(child),
#		func(parent, child, parent_cache): return not is_tile_occupied(child),
		func(parent, child, parent_cache): return parent,
	)
	
	if to not in cache:
		Logger.log_error("Should not reach")
		return []
	
	var res: Array[Vector2i] = []
	var backtrace = to
	while backtrace != null:
		res.append(backtrace)
		backtrace = cache[backtrace]
		
	return res

func is_tile_occupied(tile: Vector2i) -> bool:
	return tile in blocking_tiles

func get_burst(origin: Vector2i, size: Size, destination: Vector2i) -> Array:
	var distance = get_distance(origin, size, destination)
	return get_sensors(origin, size, distance, true)

func get_sensors(origin: Vector2i, size: Size, sensors: int, ignore_los: bool=false) -> Array:
	var cache := {}
	var origin_tiles := get_covered_tiles(origin, size)
	for p in get_covered_tiles(origin, size):
		cache[p] = sensors
		
	_floodfill(cache,
		func(parent, child, parent_cache): 
			if not ignore_los and not origin_tiles.any(func(x): return has_line_of_sight(x, child)):
				return false
			return parent_cache > 0, # TODO: abstacles
		func(parent, child, parent_cache): return parent_cache - 1,
	)
	
	return cache.keys()

func update_visible_tiles() -> void:
	visible_tiles = always_visible_tiles.duplicate()
	if fow_effect == FOWEffect.NoSensors:
		return
	for p in NetworkingSingleton.get_player_tokens():
		for tile in get_sensors(p.tile, p.size, p.sensor_range):
			if tile not in visible_tiles:
				visible_tiles.append(tile)

func is_in_line_of_sight(tile: Vector2i, size: Size) -> bool:
	for s in get_covered_tiles(tile, size):
		if s in visible_tiles:
			return true
	return false
