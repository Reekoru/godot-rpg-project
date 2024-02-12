extends Interactable
class_name NPC


var ray = RayCast2D.new()
var previous_tile = Vector2()
var target_tile = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	position = position.snapped(Vector2(Global.TILE_SIZE, Global.TILE_SIZE))
	previous_tile = position
	target_tile = position
	create_ray()


func move(num_tiles, direction : Vector2, move_speed : float):
	# Moves NPC to a tile (Needs to be worked on
	if(ray.is_colliding()):
		position = previous_tile
		target_tile = previous_tile
	else:
		position += move_speed * direction

	if(position.distance_to(previous_tile) >= Global.TILE_SIZE - move_speed):
		position = target_tile

	if(position == target_tile):
		#get_move_direction()
		previous_tile = position
		target_tile += direction * Global.TILE_SIZE

func create_ray():
	ray = RayCast2D.new()
	ray.position = $CollisionShape2D.position
	ray.cast_to = Vector2(0, $CollisionShape2D.get_shape().extents.y)
	ray.collide_with_areas = true
	ray.collide_with_bodies = true
	ray.enabled = true
	add_child(ray)
