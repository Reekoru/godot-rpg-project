extends Area2D
class_name NPC

export(String) var npc_name = ""
export(String) var dialogue_path = ""
export(String) var direct_name = ""
export(String, MULTILINE) var direct_text = ""
export(Resource) var voice
export(float) var text_speed = 0.01
export(float) var pause_text_speed = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func can_interact(interaction_component : Node) -> bool:
	print(interaction_component.get_parent() is Player)
	return interaction_component.get_parent() is Player

func interact(interaction_component : Node) -> void:
	print("Interact")
