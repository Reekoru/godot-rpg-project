extends KinematicBody2D
class_name Player

export var speed = 64

enum {
	FREE,
	INTERACT
}

var state : int = FREE
var is_interacting : bool = false

var motion = Vector2()
var velocity = Vector2()
var inventory : Array = []

func _ready():
	pass
	


func _process(delta):
	get_input_direction()
	match state:
		FREE:
			if(motion.x == 1):
				$Sprite.set_flip_h(false)
			elif(motion.x == -1):
				$Sprite.set_flip_h(true)
			if(motion != Vector2.ZERO):
				$AnimationPlayer.play("Run")
			else:
				$AnimationPlayer.play("Idle")
				
			if(is_interacting):
				change_state(INTERACT)
			
			velocity = motion.normalized() * speed * (int(Input.is_action_pressed("run")) + 1)
			move_and_slide(velocity)
		
		INTERACT:
			motion = Vector2.ZERO
			$AnimationPlayer.play("Idle")
			if(!is_interacting):
				change_state(FREE)

func change_state(target_state : int):
	state = target_state

func get_input_direction():
	var key_left = Input.is_action_pressed("ui_left")
	var key_right = Input.is_action_pressed("ui_right")
	var key_up = Input.is_action_pressed("ui_up")
	var key_down = Input.is_action_pressed("ui_down")
	
	if(key_right):
		motion.x = 1
	elif(key_left):
		motion.x = -1
	elif(!key_right || !key_left):
		motion.x = 0
	
	if(key_up || key_down):
		motion.y = -int(key_up) + int(key_down) # Get horizontal motion
	elif(!key_right || !key_left):
		motion.y = 0


func _on_InteractableComponent_on_interactable_change(new_interactable):
	if(new_interactable != null):
		change_state(INTERACT)
	else:
		change_state(FREE)


func _on_InteractableComponent_on_interact(interactable):
	pass
	#change_state(INTERACT)
