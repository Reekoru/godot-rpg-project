extends StaticBody2D
class_name Chest

var item : Node
var is_open : bool = false

var dialogue_path = "res://Assets/Dialogue/dial_consumable.json"

func _ready():
	for i in get_child_count():
		if(get_child(i).get_class() == "StaticBody2D"):
			item = get_child(i)
			break
			
func can_interact(interaction_component : Node) -> bool:
	return !is_open

func interact(interaction_component : Node) -> void:
	if(!is_open):
		$Sprite.frame = 1
		# Plays default dialouge (Cnsumable dialogue)
		interaction_component.get_parent().inventory.append(item.consumable_name) # Stores item in player
		var dialogue_scene = load("res://Assets/DialogueNode.tscn")
		var dialogue_instance = dialogue_scene.instance()
		dialogue_instance.consumable_name = item.consumable_name
		dialogue_instance.dialogue_path = dialogue_path
		dialogue_instance.consumable_color = item.consumable_color
		add_child(dialogue_instance)
		dialogue_instance.connect("dialogue_finish", interaction_component, "_on_DialogueNode_dialogue_finish") # Connect signal to parent
		dialogue_instance.connect("dialogue_finish", self, "_on_DialogueNode_dialogue_finish") # Connect signal to self
		is_open = true
		
		# Updates area 2d
		interaction_component.get_child(0).disabled = true
		interaction_component.get_child(1).start()
		yield(interaction_component.get_child(1), "timeout") 
		interaction_component.get_child(0).disabled = false

func _on_DialogueNode_dialogue_finish():
	item.queue_free()
	
