tool
extends Sprite

export(Texture) var sprite_texture setget _update_texture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _update_texture(new):
	texture = new
