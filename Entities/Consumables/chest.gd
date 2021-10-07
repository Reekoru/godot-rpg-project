extends Area2D
class_name Chest

var item : Node
var is_open : bool = false

var dialogue_path = "res://Assets/Dialogue/dial_consumable.json"

signal interaction_finished(interactable)

func _ready():
	for i in get_child_count():
		if(get_child(i).get_class() == "Area2D"):
			item = get_child(i)
			break
			
func can_interact(interaction_component : Node) -> bool:
	return !is_open

func interact(interaction_component : Node) -> void:
	if(!is_open):
		connect("interaction_finished", interaction_component, "_on_Interactable_interaction_finished")
		$Sprite.frame = 1
		interaction_component.get_child(0).disabled = true
		
		# Plays default dialouge (Consumable dialogue)
		var dialogue_scene = load("res://Assets/DialogueNode.tscn")
		var dialogue_instance = dialogue_scene.instance()
		
		dialogue_instance.consumable_name = item.consumable_name
		dialogue_instance.dialogue_path = dialogue_path
		dialogue_instance.consumable_color = item.consumable_color
		
		add_child(dialogue_instance)
		yield(dialogue_instance, "dialogue_finished")
		
		
		emit_signal("interaction_finished", self)
		
		interaction_component.get_child(0).disabled = false
		
		item.queue_free()
		is_open = true
		
		# Disconnect signal
		disconnect("interaction_finished", interaction_component, "_on_Interactable_interaction_finished")
