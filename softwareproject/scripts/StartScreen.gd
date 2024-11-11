# StartScreen.gd
extends Control

func _ready():
	# Assuming buttons have been named for their functions (e.g., "StartButton", "OptionsButton")
	$StartButton.pressed.connect(_on_start_button_pressed)
	$SettingsButton.pressed.connect(_on_settings_button_pressed)
	$SoundButton.pressed.connect(_on_settings_button_pressed)

func _on_start_button_pressed():
	# Transition to the main game scene
	get_tree().change_scene_to_file("res://Scenes/tile_map.tscn")

func _on_settings_button_pressed():
	# Open the options menu or perform another action
	print("Options button pressed")
	VideoSettings.show()
	
func _on_sound_button_pressed():
	# Open the options menu or perform another action
	print("Sound button pressed")
	AudioSettings.show()
