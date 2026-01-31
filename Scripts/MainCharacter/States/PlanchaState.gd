extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var walk_state:State
@export var run_state:State

func on_enter():
	animation_player.play("Plancha")
	await animation_player.animation_finished 
	
func state_process(_delta: float) -> void:
	var is_running = Input.is_action_pressed("CorrerP1")
		
	if is_zero_approx(father.velocity.x):
		next_state = idle_state
		return
	else:
		if is_running:
			next_state = run_state
			return
		else:
			next_state = walk_state
			return
