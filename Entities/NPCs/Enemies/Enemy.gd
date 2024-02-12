extends Interactable
class_name Enemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_EnemyDog_area_entered(area):
	if(area is Player):
		Transition.play_transition()
		yield(Transition.animation_player, "animation_finished")
		get_tree().change_scene("res://Scenes/scn_battleground.tscn")
