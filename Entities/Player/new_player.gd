extends Sprite
class_name Player

export(int) var walk_speed = 64
export(int) var run_speed = 128
var speed = 64
const TILE_SIZE : int = 16

var previous_tile = Vector2()
var target_tile = Vector2()
var move_direction = Vector2()
var current_direction = Vector2()
var current_position = Vector2()
var previous_position = Vector2()


enum {
	FREE,
	INTERACT
}

var state : int = FREE

onready var ray = $RayCast2D
onready var animation_player = $AnimationPlayer
onready var interaction_component = $InteractionComponent

func _ready():
	# Snap player to grid
	position = position.snapped(Vector2(TILE_SIZE, TILE_SIZE))
	previous_tile = position
	target_tile = position
	current_position = position

func _process(delta):
	match state:
		FREE:
			if(Input.is_action_pressed("run")): 
				speed = run_speed
			else:
				speed = walk_speed
			
			if(ray.is_colliding()):
				position = previous_tile
				target_tile = previous_tile
			else:
				position += speed * move_direction * delta
			
			if(position.distance_to(previous_tile) >= TILE_SIZE - speed * delta):
				position = target_tile
				
			if(position == target_tile):
				get_move_direction()
				previous_tile = position
				target_tile += move_direction * TILE_SIZE
				
			if(previous_position != current_position):
				previous_position = current_position
			current_position = position
			
			if(previous_position != current_position):
				play_move_animation()
			else:
				play_idle_animation()
				
			if(interaction_component.is_interacting):
				change_state(INTERACT)
				
		INTERACT:
			move_direction = Vector2.ZERO
			
			if(!interaction_component.is_interacting):
				change_state(FREE)

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
		ray.cast_to = move_direction * TILE_SIZE / 2
		current_direction = move_direction
		
	
func play_move_animation():
	set_flip_h(false)
	if(current_direction== Vector2.LEFT || current_direction == Vector2.RIGHT):
		animation_player.play("Walk_Side")
		set_flip_h(is_number_negative(current_direction.x))
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

func is_number_negative(num : int) -> bool:
	if(num < 0): return true; return false
	
func change_state(target_state):
	state = target_state
