extends Interactable
class_name Chest

var item : Node
var is_open : bool = false

var dialogue_path = "res://Assets/Dialogue/dial_consumable.json"

func _ready():
	for child in get_children():
		if(child is Consumable):
			item = child
			break
			
func can_interact(interaction_component : Node) -> bool:
	return !is_open

func interact(interaction_component : Node) -> void:
	if(!is_open):
		connect_interaction_signal(interaction_component)
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
		
		
		emit_interaction_signal()
		
		interaction_component.get_child(0).disabled = false
		
		item.queue_free()
		is_open = true
		
		# Disconnect signal
		disconnect_interaction_signal(interaction_component)
