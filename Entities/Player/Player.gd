extends Area2D
class_name Player, "res://Assets/Sprites/Player/img_player.png"

var interactable_parent : NodePath

signal movement_finished(tile)

export(int) var walk_speed = 64
export(int) var run_speed = 128

onready var collision_shape = $CollisionShape2D
onready var interaction_timer = $InteractionTimer
onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite

var ray = RayCast2D.new()
var interaction_target : Node
var is_interacting : bool = false

var previous_tile = Vector2()
var target_tile = Vector2()
var move_direction = Vector2()
var current_direction = Vector2()
var current_position = Vector2()
var previous_position = Vector2()

var inventory = []

var speed = 64

enum {
	FREE,
	INTERACT
}

signal on_interactable_change(new_interactable)
signal on_interact(interactable)

var state : int = FREE

func _ready():
	# Snap player to grid
	position = position.snapped(Vector2(Global.TILE_SIZE, Global.TILE_SIZE))
	previous_tile = position
	target_tile = position
	current_position = position
	create_ray()


func _process(delta):
	check_collision()
	match state:
		FREE:
			if(Input.is_action_pressed("run")): 
				speed = run_speed * delta
			else:
				speed = walk_speed * delta
				
			move(speed)
			
			if(is_interacting):
				change_state(INTERACT)
				
		INTERACT:
			target_tile = position
			previous_tile = position
			#move_direction = Vector2.ZERO
			if(!is_interacting):
				change_state(FREE)
	
func change_state(target_state):
	state = target_state
	
func get_move_direction():
	var LEFT = Input.is_action_pressed("left")
	var RIGHT = Input.is_action_pressed("right")
	var UP = Input.is_action_pressed("up")
	var DOWN = Input.is_action_pressed("down")
	
	move_direction.x = -int(LEFT) + int(RIGHT)
	move_direction.y = -int(UP) + int(DOWN)
	
	if(move_direction.x != 0 && move_direction.y != 0):
		move_direction = Vector2.ZERO
		
	if(move_direction != Vector2.ZERO):
		ray.cast_to = move_direction * Global.TILE_SIZE / 2
		current_direction = move_direction
	
func check_collision():
	# Check for collision and if object is interactable
	if(current_direction == Vector2.RIGHT):
		collision_shape.rotation_degrees = 270
	elif(current_direction == Vector2.LEFT):
		collision_shape.rotation_degrees = 90
	elif(current_direction == Vector2.UP):
		collision_shape.rotation_degrees = 180
	else:
		collision_shape.rotation_degrees = 0
		
	if(interaction_target != null && Input.is_action_just_pressed("ui_accept") && !is_interacting):
		if(interaction_target.has_method("interact")):
			is_interacting = true
			interaction_target.interact(self) # Call the interaction function of interactable component
			emit_signal("on_interact", interaction_target)
	
func create_ray():
	ray = RayCast2D.new()
	ray.position = collision_shape.position
	ray.cast_to = Vector2(0, collision_shape.get_shape().length)
	ray.collide_with_areas = true
	ray.collide_with_bodies = true
	ray.enabled = true
	add_child(ray)
	
func move(move_speed : float):
	# Moves Node to tile
	# Use delta from the _process function for smooth movement
	
	if(ray.is_colliding()):
		position = previous_tile
		target_tile = previous_tile
	else:
		position += move_speed * move_direction
	
	if(position.distance_to(previous_tile) >= Global.TILE_SIZE - move_speed):
		position = target_tile
	
	if(position == target_tile):
		get_move_direction()
		previous_tile = position
		target_tile += move_direction * Global.TILE_SIZE
		
	if(previous_position != current_position):
		previous_position = current_position
	current_position = position

	if(previous_position != current_position):
		play_move_animation()
	else:
		play_idle_animation()
	
func play_move_animation():
	sprite.set_flip_h(false)
	if(current_direction== Vector2.LEFT || current_direction == Vector2.RIGHT):
		animation_player.play("Walk_Side")
		sprite.set_flip_h(current_direction.x < 0)
	elif(current_direction == Vector2.UP):
		animation_player.play("Walk_Back")
	else:
		animation_player.play("Walk_Front")
		
func play_idle_animation():
	if(current_direction == Vector2.LEFT || current_direction == Vector2.RIGHT):
		animation_player.play("Idle_Side")
	elif(current_direction == Vector2.UP):
		animation_player.play("Idle_Back")
	else:
		animation_player.play("Idle_Front")
	
func _on_InteractionComponent_area_entered(area):
	print('Area Entered')
	var can_interact = false
	if(area.has_method("can_interact")):
		can_interact = area.can_interact(self)
		
	if(!can_interact): # Cannot interact with object
		interaction_target = null
		return # Do not interact
		
	interaction_target = area
	emit_signal("on_interactable_change", interaction_target)
	
func _on_InteractionComponent_area_exited(area):
	print("Area Exited")
	if(area == interaction_target):
		interaction_target = null
		emit_signal("on_interactable_change", null)
	
func _on_Interactable_interaction_finished(interactable):
	interaction_timer.start()
	yield(interaction_timer, "timeout")
	is_interacting = false
