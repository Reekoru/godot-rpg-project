extends NPC

export(String, FILE, "*.json") var dialogue_path = ""
export(String) var direct_name = ""
export(String, MULTILINE) var direct_text = ""
export(String, FILE, "*.ogg, *.wav") var voice
export(float) var text_speed = 0.01
export(float) var pause_text_speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func interact(interaction_component : Node) -> void:
	# Connect signal
	connect_interaction_signal(interaction_component)
	# Instance Scene
	var dialogue = load("res://Assets/DialogueNode.tscn").instance()
	
	dialogue.direct_text = direct_text
	dialogue.direct_name = direct_name
	
	if(!dialogue_path.empty()):
		dialogue.dialogue_path = dialogue_path # Set dialogue
	if(voice != null):
		dialogue.voice = voice # Set voice
		
	dialogue.text_speed = text_speed
	dialogue.pause_text_speed = pause_text_speed
	
	add_child(dialogue)
	
	yield(dialogue, "dialogue_finished")
	
	emit_interaction_signal()
	
	# Disconnect signal
	disconnect_interaction_signal(interaction_component)

func get_move_direction():
	pass
