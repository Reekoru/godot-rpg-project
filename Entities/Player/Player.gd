extends KinematicBody2D
class_name Player

export var speed = 48
export var sprint_percentage = 0.75

enum {
	FREE,
	INTERACT
}

var state : int = FREE

var motion = Vector2()
var velocity = Vector2()
var inventory : Array = []
var current_direction = Vector2()

func _ready():
	pass
	


func _process(delta):
	
	match state:
		FREE:
			get_input_direction()
			if($InteractableComponent.is_interacting):
				change_state(INTERACT)
			
			velocity = motion.normalized() * speed * ((int(Input.is_action_pressed("run") ) * sprint_percentage) + 1)
			move_and_slide(velocity)
		
		INTERACT:
			motion = Vector2.ZERO
			play_idle_animation()
			if(!$InteractableComponent.is_interacting):
				change_state(FREE)

func change_state(target_state : int):
	state = target_state

func get_input_direction():
	var key_left = Input.is_action_pressed("ui_left")
	var key_right = Input.is_action_pressed("ui_right")
	var key_up = Input.is_action_pressed("ui_up")
	var key_down = Input.is_action_pressed("ui_down")
	
	
	if(key_right || key_left):
		motion.x = -int(key_left) + int(key_right)
		$Sprite.set_flip_h(is_number_negative(motion.x))
		current_direction = Vector2(-int(key_left) + int(key_right), 0)
	else:
		motion.x = 0
	
	if(key_up || key_down):
		$Sprite.set_flip_h(false)
		motion.y = -int(key_up) + int(key_down) # Get horizontal motion
		current_direction = Vector2(0, -int(key_up) + int(key_down))
	else:
		motion.y = 0
	
	if(motion == Vector2.ZERO): play_idle_animation(); play_walk_animation()

func play_walk_animation():
		if(current_direction == Vector2.LEFT || current_direction == Vector2.RIGHT):
			$AnimationPlayer.play("Walk_Side")
		elif(current_direction == Vector2.UP):
			$AnimationPlayer.play("Walk_Back")
		else:
			$AnimationPlayer.play("Walk_Front")

func play_idle_animation():
	if(current_direction == Vector2.LEFT || current_direction == Vector2.RIGHT):
		$AnimationPlayer.play("Idle_Side")
	elif(current_direction == Vector2.UP):
		$AnimationPlayer.play("Idle_Back")
	else:
		$AnimationPlayer.play("Idle_Front")

func _on_InteractableComponent_on_interactable_change(new_interactable):
	if(new_interactable != null):
		change_state(INTERACT)
	else:
		change_state(FREE)

func is_number_negative(num : int) -> bool:
	if(num < 0): return true; return false
