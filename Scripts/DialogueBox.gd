extends CanvasLayer
 
export var dialogue_path = "res://Assets/Dialogue/dial_default.json"
export(String) var direct_text = ""
export(String) var direct_name = ""
export(String, FILE, "*.ogg, *.wav") var voice = "res://Assets/Dialogue/Voices/voice_default.ogg"
export(float) var text_speed = 0.02
export(float) var pause_text_speed = 0.1

signal dialogue_finished
 
var dialogue
var dialogue_animation: String
var consumable_name : String
var consumable_color : String
var phrase_num = 0
var finished = false
var animation_player

onready var timer = $Dialogue/DialogueBox/Timer
onready var voice_player = $Dialogue/DialogueBox/Voice
onready var indicator = $Dialogue/DialogueBox/Indicator
onready var dialogue_text = $Dialogue/DialogueBox/Text
onready var dialogue_name = $Dialogue/NameBox/Name
onready var dialogue_portrait = $Dialogue/DialogueBox/Portrait
onready var dialogue_name_box = $Dialogue/NameBox
onready var dialogue_box = $Dialogue/DialogueBox
 
func _ready():
	var default_voice = "res://Assets/Dialogue/Voices/voice_default.ogg"
	for child in get_parent().get_children():
		if(child.name == "Sprite"):
			animation_player = child.get_child(0)
			break
	
	timer.wait_time = text_speed
	dialogue = get_dialogue()
	assert(dialogue, "dialogue not found")
	next_phrase() # Get Phrase
	if(voice.empty()):
		voice = default_voice
	voice_player.stream = load(voice)
	
	
 
func _process(_delta):
	indicator.visible = finished # Show indicator
	$Dialogue.visible = !dialogue_text.text.empty()
	if(Input.is_action_just_pressed("ui_accept") || dialogue_text.text.empty()):
		if(finished):
			next_phrase()
		else: # Skips dialogue to end of phrase if players wants to skip
			dialogue_text.bbcode_text = dialogue_text.bbcode_text.replace("|", "") # Remove all pause character
			dialogue_text.visible_characters = len(dialogue_text.text)
 
func get_dialogue() -> Array:
	# Gets dialogue from json file
	var f = File.new()
	assert(f.file_exists(dialogue_path), "File path does not exist")
	
	f.open(dialogue_path, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
 
func next_phrase() -> void:
	# Displays dialogue to canvas and goes to next phrase (if any)
	dialogue_box.visible = true
	dialogue_name_box.visible = true
	dialogue_text.bbcode_text = ""
	dialogue_animation = ""
	
	# When dialogue is finished
	if(direct_text.empty()):
		if(phrase_num >= len(dialogue)):
			queue_free()
			emit_signal("dialogue_finished")
			print("Dialogue has finished")
			return
	else:
		if(phrase_num >= 1):
			queue_free()
			emit_signal("dialogue_finished")
			print("Dialogue has finished")
			return
	
	finished = false
	
	###### Get data from JSON ######
	match dialogue[phrase_num]["Type"]:
		
		"consumable": # Check if dialogue is consumable
			dialogue_text.bbcode_text =  dialogue[phrase_num]["Text"] + "[color=" + consumable_color + "]" + consumable_name + "[/color]"
			dialogue_name_box.visible = !dialogue[phrase_num]["Name"].empty() # Show or hide name box depending on string
			
		"animation":
			animation_player.play("anim_phrase_" + String(phrase_num))
			dialogue_box.visible = false
			dialogue_name_box.visible = false
			yield(animation_player, "animation_finished")
			finished = true
			phrase_num += 1
			return
			
		_:
			if(direct_text.empty()): # Use json file if direct text is empty
				dialogue_text.bbcode_text = dialogue[phrase_num]["Text"]
				dialogue_name.bbcode_text = "[center]" + dialogue[phrase_num]["Name"] + "[/center]"
				dialogue_name_box.visible = !dialogue[phrase_num]["Name"].empty() # Show or hide name box depending on string
				if("Animation" in dialogue[phrase_num]):
					dialogue_animation = dialogue[phrase_num]["Animation"]
				
			else: # Use direct text
				dialogue_text.bbcode_text = direct_text
				dialogue_name.bbcode_text = "[center]" + direct_name + "[/center]"
				dialogue_name_box.visible = !direct_name.empty() # Show or hide name box depending on string
			
	
	load_portrait()
	
	if(animation_player != null):
		if(!dialogue_animation.empty()):
			animation_player.play(dialogue_animation)
		else:
			animation_player.play("DEFAULT")
	# Pause dialogue when empty
	if(dialogue_text.text.empty()):
		$HideTimer.start()
		yield($HideTimer, "timeout")
		phrase_num += 1
		finished = true
		return
		
	var pause_index_text = []
	var pause_index_bbcode_text = []
	
	# Get index of when to pause in dialopgue
	var i = -1
	# Get all index of | character before removing |
	for text in dialogue_text.bbcode_text:
		i += 1
		if(text == "|"):
			pause_index_bbcode_text.append(i)
	
	i = -1
	# Get all index of | character before removing |
	for text in dialogue_text.text:
		i += 1
		if(text == "|"):
			pause_index_text.append(i)
			
	##########################################
	##### Scroll through dialogue string #####
	##########################################
	dialogue_text.visible_characters = 0
	var num_pause = 0
	while dialogue_text.visible_characters < len(dialogue_text.text):
		var text = dialogue_text.bbcode_text
		dialogue_text.visible_characters += 1 # Scrool through dialogue
		if(dialogue_text.visible_characters in pause_index_text): # If there is a pause character
			for pause in len(pause_index_text):
				pause_index_text[pause] = pause_index_text[pause] - 1 # Update Index
			for pause in len(pause_index_bbcode_text):
				pause_index_bbcode_text[pause] = pause_index_bbcode_text[pause] - 1 # Update Index
				
			text.erase(pause_index_bbcode_text[num_pause] + 1, 1) # Remove pause character
			num_pause += 1
			
			# Update dialoue text
			dialogue_text.bbcode_text = text
			timer.wait_time = pause_text_speed # Pause
		else:
			timer.wait_time = text_speed # Normal
		
		voice_player.play()
		timer.start()
		yield(timer, "timeout")
	
	### FINISH PHRASE ###
	finished = true
	phrase_num += 1
	return
	
func load_portrait():
	### Load Portrait ###
	var f = File.new()
	var img = dialogue[phrase_num]["Name"] + dialogue[phrase_num]["Emotion"] + ".png" # Get portrait if any
	if f.file_exists(img):
		dialogue_portrait.texture = load(img)
	else: dialogue_portrait.texture = null
