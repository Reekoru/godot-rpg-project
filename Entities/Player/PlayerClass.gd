extends Area2D
#class_name Player


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func move(move_speed : float):
#	# Moves Node to tile
#	# Use delta from the _process function for smooth movement
#	if(ray.is_colliding()):
#		position = previous_tile
#		target_tile = previous_tile
#	else:
#		position += move_speed * move_direction
#
#	if(position.distance_to(previous_tile) >= TILE_SIZE - move_speed):
#		position = target_tile
#
#	if(position == target_tile):
#		get_move_direction()
#		previous_tile = position
#		target_tile += move_direction * TILE_SIZE
#
#	if(previous_position != current_position):
#		previous_position = current_position
#	current_position = position
#
#	return 
#	if(previous_position != current_position):
#		play_move_animation()
#	else:
#		play_idle_animation()
