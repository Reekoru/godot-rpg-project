extends Area2D
class_name Interactable

signal interaction_finished(interactable)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func can_interact(interaction_component : Node) -> bool:
	return interaction_component is Player
	
func interact(interaction_component):
	connect_interaction_signal(interaction_component)
	print("Interacted")
	emit_interaction_signal()
	disconnect_interaction_signal(interaction_component)

func connect_interaction_signal(target : Node):
	connect("interaction_finished", target, "_on_Interactable_interaction_finished")

func disconnect_interaction_signal(target : Node):
	disconnect("interaction_finished", target, "on_Interactable_interaction_finished")

func emit_interaction_signal():
	emit_signal("interaction_finished", self)
