tool
extends Interactable
class_name Consumable, "res://Assets/Sprites/Others/sprite_cup.png"

export(String) var consumable_name = "Coffee"
export(String, "Red", "Purple", "Yellow", "Green", "Blue") var consumable_color = "Red"
export(Texture) var texture setget _update_texture

var dialogue_path = "res://Assets/Dialogue/dial_consumable.json"
# Called when the node enters the scene tree for the first time.
func _ready():
	if(texture != null):
		$Sprite.texture = texture

func interact(interaction_component : Node) -> void:
	connect_interaction_signal(interaction_component)
	# Plays default dialouge (Consumable dialogue)
	
	var dialogue_scene = load("res://Assets/DialogueNode.tscn")
	var dialogue_instance = dialogue_scene.instance()

	dialogue_instance.consumable_name = consumable_name
	dialogue_instance.dialogue_path = dialogue_path
	dialogue_instance.consumable_color = consumable_color.to_lower()

	add_child(dialogue_instance)
	
	yield(dialogue_instance, "dialogue_finished")

	emit_interaction_signal()

	interaction_component.inventory.append(consumable_name)

	# Disconnect signal
	disconnect_interaction_signal(interaction_component)
	queue_free()

func _update_texture(new_texture):
	texture = new_texture
	if(Engine.editor_hint):
		$Sprite.texture = texture
