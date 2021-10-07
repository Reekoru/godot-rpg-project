extends Area2D
class_name NPC

export(String) var dialogue_path = ""
export(String) var direct_name = ""
export(String, MULTILINE) var direct_text = ""
export(Resource) var voice
export(float) var text_speed = 0.01
export(float) var pause_text_speed = 0.5

signal interaction_finished(interactable)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func can_interact(interaction_component : Node) -> bool:
	return interaction_component.get_parent() is Player

func interact(interaction_component : Node) -> void:
	connect("interaction_finished", interaction_component, "_on_Interactable_interaction_finished")
	var dialogue_scene = load("res://Assets/DialogueNode.tscn")
	var dialogue_instance = dialogue_scene.instance()
	
	dialogue_instance.direct_text = direct_text
	dialogue_instance.direct_name = direct_name
	
	if(!dialogue_path.empty()):
		dialogue_instance.dialogue_path = dialogue_path # Set dialogue
	if(voice != null):
		dialogue_instance.voice = voice # Set voice
		
	dialogue_instance.text_speed = text_speed
	dialogue_instance.pause_text_speed = pause_text_speed
	
	add_child(dialogue_instance)
	
	yield(dialogue_instance, "dialogue_finished")
	
	emit_signal("interaction_finished", self)
