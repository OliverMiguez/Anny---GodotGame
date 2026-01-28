extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var walk_state:State
@export var run_state:State
@export var crouch_state:State

func on_enter():
	animation_player.play("Roll")
	

func state_process(_delta: float) -> void:
	
	if not animation_player.is_playing():
		# Decidimos a dónde ir dependiendo de si nos movemos o no
		if is_zero_approx(father.velocity.x):
			next_state = idle_state
		else:
			next_state = walk_state 
		return
	
	
	var is_running = Input.is_action_pressed("CorrerP1")
	var is_crouching = Input.is_action_pressed("AbajoP1")
	
	if is_zero_approx(father.velocity.x):
		if is_crouching:
			next_state = crouch_state
			return
		else:
			next_state = idle_state
			return
	else:
		if is_running:
			next_state = run_state
