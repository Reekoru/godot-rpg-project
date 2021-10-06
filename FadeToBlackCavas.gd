extends CanvasLayer


onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "fade_to_black"):
		animation_player.play("fade_to_normal")

func play_transition():
	animation_player.play("fade_to_black")
