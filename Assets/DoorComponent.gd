extends StaticBody2D


export(String, FILE, "*.tscn,*.scn") var target_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func can_interact(interaction_component : Node) -> bool:
	return interaction_component.get_parent() is Player

func interact(interaction_component) -> void:
	FadeToBlackCavas.play_transition()
	yield(FadeToBlackCavas.animation_player, "animation_finished")
	get_tree().change_scene(target_scene)
