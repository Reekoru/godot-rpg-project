extends KinematicBody2D
class_name NPC

export(String) var npc_name = ""
export(String) var dialogue_path = ""
export(String) var direct_name = ""
export(String, MULTILINE) var direct_text = ""
export(String) var voice_path = ""
export(float) var text_speed = 0.01
export(float) var pause_text_speed = 0.5


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func can_interact(interactionComponentParent : Node) -> bool:
	return interactionComponentParent is Player

func interact(interactionComponentParent : Node) -> void:
	var dialogue_scene = load("res://Assets/DialogueNode.tscn")
	var dialogue_instance = dialogue_scene.instance()
	dialogue_instance.direct_text = direct_text
	dialogue_instance.direct_name = direct_name
	if(!dialogue_path.empty()):
		dialogue_instance.dialogue_path = dialogue_path # Set dialogue
	if(!voice_path.empty()):
		dialogue_instance.voice_path = voice_path # Set voice
	dialogue_instance.text_speed = text_speed
	dialogue_instance.pause_text_speed = pause_text_speed
	add_child(dialogue_instance)
	dialogue_instance.connect("dialogue_finish", interactionComponentParent, "_on_DialogueNode_dialogue_finish")
