extends Node2D  # The root node of the door scene

@onready var animated_sprite = $Area2D/AnimationPlayer
@onready var top_collision = $Area2D/StaticBody2D/Top
@onready var bottom_collision = $Area2D/StaticBody2D/Bottom
@onready var sound_effect = $Area2D/AudioStreamPlayer2D

var is_locked = true

# Function to lock the door
func lock():
	is_locked = true
	top_collision.set_disabled(false)
	bottom_collision.set_disabled(false)
	animated_sprite.play("Close")
	print("Door locked")

func unlock():
	is_locked = false
	top_collision.set_disabled(true)
	bottom_collision.set_disabled(true)
	animated_sprite.play("Open")
	sound_effect.play()
	print("Door unlocked, collisions disabled, and open animation played.")


# Function triggered when the player enters the door's detection area
func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		if is_locked:
			print("The door is locked. Defeat all enemies to unlock.")
			return

		# Play the unlock animation and sound
		if not animated_sprite.is_playing():
			animated_sprite.play("Open")
			sound_effect.play()
