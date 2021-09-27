extends Area2D


export var interactable_parent : NodePath

signal on_interactable_change(new_interactable)
signal on_interact(interactable)

var interaction_target : Node
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
				
	if(interaction_target != null && Input.is_action_just_pressed("ui_accept") && get_parent().can_interact == true):
		if(interaction_target.has_method("interact")):
			interaction_target.interact(get_parent()) # Call the interaction function of interactable component
			emit_signal("on_interact", interaction_target)
	

func _on_InteractableComponent_body_entered(body):
	var can_interact = false
	print(body.name)
	if(body.has_method("can_interact")):
		can_interact = body.can_interact(get_node(interactable_parent))
	
	if(!can_interact):
		return # Do not interact
	
	interaction_target = body
	emit_signal("on_interactable_change", interaction_target)


func _on_InteractableComponent_body_exited(body):
	if(body == interaction_target):
		interaction_target = null
		emit_signal("on_interactable_change", null)
