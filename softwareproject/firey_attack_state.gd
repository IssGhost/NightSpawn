extends State
class_name FireyAttackState

var attack_range: float = 50.0  # Wraith attack range (can be adjusted for projectile attack)
var attack_duration: float = 0.5  # Duration of the attack (used to control attack speed)
var attack_damage: int = 10  # Damage dealt by the fireball
var cooldown_duration: float = 1.5  # Attack cooldown duration

var can_attack: bool = true

# Preload the fireball scene
var fireball_scene = preload("res://Scenes/fireball.tscn")

# Called when entering the state
func enter_state(_previous_state: State):
	print("Entering FireyAttackState")
	
	# Only attack if cooldown allows it and if player exists
	if can_attack and actor.player:
		attack()

func attack():
	# Determine direction based on the relative position of actor and player
	var direction_to_player = (actor.player.global_position - actor.global_position).normalized()

	# Spawn the fireball
	var fireball = fireball_scene.instantiate()  # Instance the fireball scene
	fireball.global_position = actor.global_position  # Set fireball start position at the actor's position

	# Initialize the fireball (set its direction and damage)
	fireball.initialize(direction_to_player, attack_damage)

	# Add the fireball to the scene
	actor.get_parent().add_child(fireball)

	# Start the attack timer (for attack duration)
	var attack_timer = Timer.new()
	attack_timer.wait_time = attack_duration
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	attack_timer.start()

	# Disable further attacks until the cooldown is over
	can_attack = false
	
	# Start the cooldown timer
	var cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown_duration
	cooldown_timer.one_shot = true
	add_child(cooldown_timer)
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_timeout"))
	cooldown_timer.start()

# Called when the attack is finished
func _on_attack_timer_timeout():
	print("Fireball attack finished, transitioning to FollowState")
	transition.emit("FollowState")  # Move back to follow state or idle state after attacking

# Called when the cooldown timer finishes
func _on_cooldown_timeout():
	print("Cooldown finished, can attack again")
	can_attack = true
	
	# After the cooldown, check if the player is still in range
	if actor.global_position.distance_to(actor.player.global_position) <= attack_range:
		# If the player is still in range, transition back to attack
		transition.emit("AttackState")
	else:
		# Otherwise, keep following the player
		transition.emit("FollowState")

func exit_state():
	print("Exiting FireyAttackState")
