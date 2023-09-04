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
		
	_on_transform_changed(transform_preview._transf)
	$V/Sprite.texture = texture
	transform_preview.sprite_size = texture.get_size()
	popup_centered()

func set_map_parameters(map: HexMap) -> void:
	transform_preview.tile_size = map.tile_size
	transform_preview.is_horizontal = map.is_horizontal

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
