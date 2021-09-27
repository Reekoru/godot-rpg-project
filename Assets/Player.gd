extends KinematicBody2D
class_name Player

export var speed = 64

enum {
	FREE,
	INTERACT
}

var state : int = FREE
var can_interact : bool = true

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
				
			if(Input.is_action_pressed("run")):
				$AnimationPlayer.playback_speed = 1.5
				speed = 128
			else:
				$AnimationPlayer.playback_speed = 1
				speed = 64
			velocity = motion.normalized() * speed
			move_and_slide(velocity)
		
		INTERACT:
			motion = Vector2.ZERO
			$AnimationPlayer.play("Idle")

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
	can_interact = false
	change_state(INTERACT)

func _on_DialogueNode_dialogue_finish():
	change_state(FREE)
	$InteractionTimer.start()
	yield($InteractionTimer, "timeout")
	print(inventory)
	can_interact = true
