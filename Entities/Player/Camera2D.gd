extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RoomSizeDetector_area_entered(area):
	var collision_shape = area.get_node("CollisionShape2D")
	var size = collision_shape.shape.extents * 2
	var view_size = get_viewport_rect().size
	
	if(size.y < view_size.y):
		size.y = view_size.y
		
	if(size.x < view_size.x):
		size.x = view_size.x
	
	limit_top = collision_shape.global_position.y - size.y/2
	limit_left = collision_shape.global_position.x - size.x/2
	limit_bottom = limit_top + size.y
	limit_right = limit_left + size.x
