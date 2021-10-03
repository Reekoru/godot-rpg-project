extends StaticBody2D
class_name Consumable, "res://Assets/Images/Others/sprite_cup.png"

export(String) var consumable_name = "Coffee"
export(String, "red", "purple", "yellow", "green", "blue") var consumable_color
export(Texture) var texture

var dialogue_path = "res://Assets/Dialogue/dial_consumable.json"
# Called when the node enters the scene tree for the first time.
func _ready():
	if(texture != null):
		$Sprite.texture = texture


func can_interact(interactionComponent : Node) -> bool:
	return interactionComponent.get_parent() is Player

func interact(interaction_component : Node) -> void:
	# Plays default dialouge (Consumable dialogue)
	interaction_component.get_parent().inventory.append(consumable_name)
	var dialogue_scene = load("res://Assets/DialogueNode.tscn")
	var dialogue_instance = dialogue_scene.instance()
	dialogue_instance.consumable_name = consumable_name
	dialogue_instance.dialogue_path = dialogue_path
	dialogue_instance.consumable_color = consumable_color
	add_child(dialogue_instance)
	dialogue_instance.connect("dialogue_finish", interaction_component, "_on_DialogueNode_dialogue_finish") # Connect signal to parent
	dialogue_instance.connect("dialogue_finish", self, "_on_DialogueNode_dialogue_finish") # Connect signal to self
	
func _on_DialogueNode_dialogue_finish():
	queue_free()
