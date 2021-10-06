extends Area2D

export(String, FILE, "*.tscn,*.scn") var target_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	if(body is Player):
		FadeToBlackCavas.play_transition()
		yield(FadeToBlackCavas.animation_player, "animation_finished")
		get_tree().change_scene(target_scene)
