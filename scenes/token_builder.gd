class_name TokenBuilder
extends AcceptDialog

@export var size_buttons: ButtonGroup

var token: Token
var is_confirmed := false

@onready var transform_preview: TransformPreview = $V/Sprite/TransformPreview
	
signal setup_complete
signal request_remove(token: Token)

func _ready():
	size_buttons.pressed.connect(_on_size_button_pressed)
	add_button("Kill", true, "kill")

func setup(p_token: Token, raw_texture: Texture2D=null) -> void:
	token = p_token
	var texture: Texture2D
	if raw_texture != null:
		var img := raw_texture.get_image()
		var png_buffer := img.save_png_to_buffer()
		while len(png_buffer) > 0xFFFF - 9:
			img.shrink_x2()
			png_buffer = img.save_png_to_buffer()
		texture = ImageTexture.create_from_image(img)
		token.set_sprite(texture)
	else:
		texture = token.get_sprite()
	
	transform_preview.set_transform(token.get_add_transform().affine_inverse())
	#transform_preview.set_transform(Transform2D.IDENTITY.scaled(Vector2.ONE* 1000))
	#_on_transform_changed(transform_preview._transf)
	
	var relevant_button = size_buttons.get_buttons().filter(func(x): return x.get_meta("size", 0) == token.size).pop_back()
	if relevant_button != null:
		relevant_button.button_pressed = true
	#transform_preview.set_token_size(token.size)
	$V/IsPlayer.button_pressed = token.is_player
	$V/Sensors/SpinBox.value = token.sensor_range
	$V/Sprite.texture = texture
	transform_preview.sprite_size = texture.get_size()
	popup_centered()

func set_map_parameters() -> void:
	transform_preview.tile_size = Grid.tile_size
	transform_preview.is_horizontal = Grid.is_horizontal

func _on_size_button_pressed(button: BaseButton) -> void:
	var size: int = button.get_meta("size")
	transform_preview.set_token_size(size)
	if is_instance_valid(token):
		token.size = size

func _on_confirmed() -> void:
	is_confirmed = true
	setup_complete.emit()
	token.data_changed.emit(token)

func _on_canceled() -> void:
	is_confirmed = false
	setup_complete.emit()

func _on_transform_changed(transf: Transform2D) -> void:
	if not is_instance_valid(token):
		return
	token.set_add_transform(transf.affine_inverse())

func _on_custom_action(action: String) -> void:
	if action == "kill" and is_instance_valid(token):
		request_remove.emit(token)
		hide()

func _on_is_player_toggled(button_pressed: bool) -> void:
	$V/Sensors.visible = button_pressed
	token.is_player = button_pressed

func _on_sensors_changed(value: int) -> void:
	token.sensor_range = value
