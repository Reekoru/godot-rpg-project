extends Area2D
class_name Consumable, "res://Assets/Images/Others/sprite_cup.png"

export(String) var consumable_name = "Coffee"
export(String, "red", "purple", "yellow", "green", "blue") var consumable_color = "red"
export(Texture) var texture

signal interaction_finished(interactable)

var dialogue_path = "res://Assets/Dialogue/dial_consumable.json"
# Called when the node enters the scene tree for the first time.
func _ready():
	if(texture != null):
		$Sprite.texture = texture


func can_interact(interactionComponent : Node) -> bool:
	return interactionComponent.get_parent() is Player

func interact(interaction_component : Node) -> void:
	connect("interaction_finished", interaction_component, "_on_Interactable_interaction_finished")
	# Plays default dialouge (Consumable dialogue)
	
	var dialogue_scene = load("res://Assets/DialogueNode.tscn")
	var dialogue_instance = dialogue_scene.instance()
	
	dialogue_instance.consumable_name = consumable_name
	dialogue_instance.dialogue_path = dialogue_path
	dialogue_instance.consumable_color = consumable_color
	
	add_child(dialogue_instance)
	
	yield(dialogue_instance, "dialogue_finished")
	
	emit_signal("interaction_finished", self)
	
	interaction_component.get_parent().inventory.append(consumable_name)
	
	# Disconnect signal
	disconnect("interaction_finished", interaction_component, "_on_Interactable_interaction_finished")
	queue_free()
