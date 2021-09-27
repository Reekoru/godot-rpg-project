extends StaticBody2D
class_name Consumable

export(String) var consumable_name = "Coffee"
export(String, "red", "purple", "yellow", "green", "blue") var consumable_color
export(Texture) var texture

var dialogue_path = "res://Dialogue/dial_consumable.json"
# Called when the node enters the scene tree for the first time.
func _ready():
	if(texture != null):
		$Sprite.texture = texture


func can_interact(interactionComponentParent : Node) -> bool:
	return interactionComponentParent is Player

func interact(interactionComponentParent : Node) -> void:
	# Plays default dialouge (Cnsumable dialogue)
	interactionComponentParent.inventory.append(consumable_name)
	var dialogue_scene = load("res://Assets/DialogueNode.tscn")
	var dialogue_instance = dialogue_scene.instance()
	dialogue_instance.consumable_name = consumable_name
	dialogue_instance.dialogue_path = dialogue_path
	dialogue_instance.consumable_color = consumable_color
	add_child(dialogue_instance)
	dialogue_instance.connect("dialogue_finish", interactionComponentParent, "_on_DialogueNode_dialogue_finish") # Connect signal to parent
	dialogue_instance.connect("dialogue_finish", self, "_on_DialogueNode_dialogue_finish") # Connect signal to self

func _on_DialogueNode_dialogue_finish():
	queue_free()
