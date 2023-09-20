class_name TransformPreview
extends Control

const UNITY_HEXAGON_S1 := [
	Vector2(.25,  0),
	Vector2(.75,  0),
	Vector2(  1, .5),
	Vector2(.75,  1),
	Vector2(.25,  1),
	Vector2(  0, .5),
	Vector2(.25,  0),
]

const OFFSETS = [
	[
		Vector2(0, 0)
	],
	[
		Vector2(   0,    0),
		Vector2( .75,  0.5),
		Vector2( .75, -0.5),
	],
	[
		Vector2(   0,   1),
		Vector2(   0,  -1),
		Vector2(-.75,  .5),
		Vector2(-.75, -.5),
		Vector2( .75,  .5),
		Vector2( .75, -.5),
	],
	[
		Vector2(-.75,   .5),
		Vector2(-.75,  -.5),
		Vector2(   0,    0),
		Vector2(   0,    1),
		Vector2(   0,   -1),
		Vector2( .75,  1.5),
		Vector2( .75,   .5),
		Vector2( .75,  -.5),
		Vector2( .75, -1.5),
		Vector2( 1.5,    0),
		Vector2( 1.5,    1),
		Vector2( 1.5,   -1),
	]
]

var _transf := Transform2D.IDENTITY

var origin := Vector2.ZERO
var right := Vector2.RIGHT

var dragging := false

var _token_size := 1

signal transform_changed(transf: Transform2D)

var draw_transf: Transform2D
var inv_draw_transf: Transform2D

var tile_size: Vector2
var is_horizontal: bool

var sprite_size: Vector2

func _draw():
	var draw_scale_vec  := tile_size*size/sprite_size*.5
	var draw_scale = draw_scale_vec[draw_scale_vec.min_axis_index()]
	draw_transf = Transform2D(0, Vector2.ONE * draw_scale, 0, Vector2.ONE * size.x/2)
	inv_draw_transf = draw_transf.affine_inverse()
	
	var hex = PackedVector2Array(UNITY_HEXAGON_S1)
	var offsets = OFFSETS[_token_size - 1]
	draw_circle(draw_transf * Vector2.ZERO, 2, Color.RED)
	for offset in offsets:
		for i in range(len(hex)):
			var pt = (2*(UNITY_HEXAGON_S1[i] + offset) - Vector2.ONE)
			#pt.y *= tile_size.x / tile_size.y
			if is_horizontal:
				pt = pt.rotated(PI/2)
			hex[i] = draw_transf * (_transf * pt)
		draw_polyline(hex, Color.RED, 2, true)
	if dragging:
		draw_line(
			draw_transf * origin,
			draw_transf * (origin + right),
			Color.RED
		)
	
func set_transform(transf: Transform2D) -> void:
	_transf = transf
	right = transf.x
	origin = transf.origin
	
func set_token_size(p_size: int) -> void:
	_token_size = p_size
	queue_redraw()
		
func _snap_to_axes(inp: Vector2, tolerance: float=0.1) -> Vector2:
	if Input.is_key_pressed(KEY_ALT):
		return inp
	if abs(inp.x) < tolerance:
		inp.x = 0
	if abs(inp.y) < tolerance:
		inp.y = 0
	return inp
	
func _on_gui_input(event: InputEvent) -> void:
	var draw_scale = (sprite_size/tile_size).x
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			origin = inv_draw_transf * event.position
			if origin.length() < 0.1 * draw_scale and not Input.is_key_pressed(KEY_ALT):
				origin = Vector2.ZERO
			dragging = true
		else:
			right = _snap_to_axes(inv_draw_transf * (event.position - origin) /2, 0.05*draw_scale)
			_transf = Transform2D(right, right.rotated(PI/2), origin)
			transform_changed.emit(_transf)
			dragging = false
			queue_redraw()
	elif  event is InputEventMouseMotion and dragging:
		right = _snap_to_axes(inv_draw_transf * (event.position - origin) /2, 0.05*draw_scale)
		_transf = Transform2D(right, right.rotated(PI/2), origin)
		queue_redraw()
