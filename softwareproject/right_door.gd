extends Node2D  # The Node2D handles door logic, Area2D handles detection

@onready var animated_sprite = $Area2D/AnimationPlayer  # Use AnimationPlayer for the door animation
@onready var blocking_body = $StaticBody2D  # The StaticBody2D for blocking the player's movement
@onready var sound_effect = $Area2D/AudioStreamPlayer2D

var animation_played = false  # Flag to track if the animation has been played
var is_locked = false

# Function to lock the door
func lock():
	is_locked = true
	blocking_body.disabled = false  # Enable collision to block player
	animated_sprite.play("Close")

# Function to unlock the door
func unlock():
	is_locked = false
	blocking_body.disabled = true  # Disable collision to allow passage
	animated_sprite.play("Open")
func _ready():
	# No need to adjust collision layers here, as handled by the StaticBody2D node setup
	pass

# Function triggered when player enters the door's collision area
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):  # Assuming the player is in the "player" group
		print("Player collided with the door")
		
		# Only play the animation if it hasn't already been played
		if not animation_played:
			# Play the door animation (could be an opening animation)
			animated_sprite.play("Open")  # Play the "Right" animation for the door
			sound_effect.play()
			animation_played = true  # Set the flag to true to prevent replaying

# Function called when the animation is finished
func _on_animation_finished():
	# Stop the animation to ensure it doesn't play again
	animated_sprite.stop()  # Stop the animation
