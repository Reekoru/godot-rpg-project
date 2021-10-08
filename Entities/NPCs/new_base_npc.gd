tool
extends Interactable
class_name NPC

export(Texture) var sprite_texture setget _update_sprite_texture
	

export(String) var dialogue_path = ""
export(String) var direct_name = ""
export(String, MULTILINE) var direct_text = ""
export(Resource) var voice
export(float) var text_speed = 0.01
export(float) var pause_text_speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture = sprite_texture

func can_interact(interaction_component : Node) -> bool:
	return interaction_component is Player

func interact(interaction_component : Node) -> void:
	# Connect signal
	connect_interaction_signal(interaction_component)
	
	# Instance Scene
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
	
	# Add as a child
	add_child(dialogue_instance)
	
	yield(dialogue_instance, "dialogue_finished")
	
	emit_interaction_signal()
	
	# Disconnect signal
	disconnect_interaction_signal(interaction_component)

func _update_sprite_texture(new_sprite):
	sprite_texture = new_sprite
	if(Engine.editor_hint):
		$Sprite.texture = sprite_texture
