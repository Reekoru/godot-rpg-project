extends Area2D

export var interactable_parent : NodePath

onready var parent = get_parent()
onready var collision_shape = $CollisionShape2D
onready var interaction_timer = $InteractionTimer

var current_direction = Vector2()
var interaction_target : Node
var is_interacting : bool = false

signal on_interactable_change(new_interactable)
signal on_interact(interactable)

func _ready():
	current_direction = parent.current_direction


func _process(delta):
	current_direction = parent.current_direction
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
	


func _on_InteractionComponent_area_entered(area):
	print("Entered Area")
	var can_interact = false
	if(area.has_method("can_interact")):
		can_interact = area.can_interact(self)
	if(!can_interact): # Cannot interact with object
		interaction_target = null
		return # Do not interact
	
	interaction_target = area
	emit_signal("on_interactable_change", interaction_target)


func _on_InteractionComponent_area_exited(area):
	print("Exited Area")
	if(area == interaction_target):
		interaction_target = null
		emit_signal("on_interactable_change", null)

func _on_Interactable_interaction_finished(interactable):
	interaction_timer.start()
	yield(interaction_timer, "timeout")
	is_interacting = false
