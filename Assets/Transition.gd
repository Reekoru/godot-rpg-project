extends CanvasLayer


onready var animation_player = $AnimationPlayer
onready var color_rect = $ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.color = Color(0,0,0,0)

func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "fade_to_black"):
		animation_player.play("fade_to_normal")

func play_transition():
	animation_player.play("fade_to_black")
