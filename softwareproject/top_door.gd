extends Node2D  # The Node2D handles door logic, Area2D handles detection

@onready var animated_sprite = $Area2D/TopDoorAnimation  # Door's AnimatedSprite2D
@onready var blocking_body = $StaticBody2D  # The StaticBody2D for blocking the player's movement
@onready var sound_effect = $Area2D/AudioStreamPlayer2D

var animation_played = false
var room_ref = null  # Reference to the room this door is in

func _ready():
	# The StaticBody2D should start with the collision active (blocking the player).
	blocking_body.collision_layer = 2  # Set to the appropriate layer for blocking the player

# Function to set the room reference
func set_room(room):
	room_ref = room

# Function triggered when player enters the door's collision area
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):  # Assuming the player is in the "player" group
		print("Player collided with the door")
		
		# Check if the room still has enemies
		if room_ref != null and room_ref.has_enemies():
			print("Room has enemies, door will stay locked.")
			return  # Exit the function if there are enemies
		
		if animation_played == false:
			# Play the door animation (this could be an opening or closing animation)
			animated_sprite.play("Top")  # Play the correct animation for the door
			sound_effect.play()

# Function called when the animation is finished
func _on_animation_finished():
	# Disable the blocking collision so the player can move through the door
	blocking_body.collision_layer = 0  # Remove the collision so the player can pass through
	animation_played = true
