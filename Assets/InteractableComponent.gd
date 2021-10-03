extends Area2D


export var interactable_parent : NodePath

signal on_interactable_change(new_interactable)
signal on_interact(interactable)

var interaction_target : Node
var is_interacting : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	# Change direction of collision ray based on player input
	var parent = get_parent()
	if(parent.motion != Vector2.ZERO):
		if(parent.motion.y != 0 && parent.motion.x == 0):
			if(parent.motion.y == 1):
				$CollisionShape2D.position = Vector2(0, 0)
			elif(parent.motion.y == -1):
				$CollisionShape2D.position = Vector2(0, -6)
		elif(parent.motion.x != 0 && parent.motion.y == 0):
			if(parent.motion.x == 1):
				$CollisionShape2D.position = Vector2(4, -2.5)
			elif(parent.motion.x == -1):
				$CollisionShape2D.position = Vector2(-4, -2.5)
				
	if(interaction_target != null && Input.is_action_just_pressed("ui_accept") && !is_interacting):
		if(interaction_target.has_method("interact")):
			interaction_target.interact(self) # Call the interaction function of interactable component
			is_interacting = true
			emit_signal("on_interact", interaction_target)
	
	parent.is_interacting = is_interacting
	

func _on_InteractableComponent_body_entered(body):
	var can_interact = false
	if(body.has_method("can_interact")):
		can_interact = body.can_interact(self)
	if(!can_interact): # Cannot interact with object
		interaction_target = null
		return # Do not interact
	
	interaction_target = body
	emit_signal("on_interactable_change", interaction_target)


func _on_InteractableComponent_body_exited(body):
	if(body == interaction_target):
		interaction_target = null
		emit_signal("on_interactable_change", null)

func _on_DialogueNode_dialogue_finish():
	$InteractionTimer.start()
	yield($InteractionTimer, "timeout")
	is_interacting = false
	print(get_parent().inventory)
