extends "res://Scripts/GeneralStates/Util/State.gd"

@export var walk_state:State
@export var run_state:State
@export var crouch_state:State
@export var jump_state:State
@export var roll_state:State
@export var plancha_state:State

func on_enter():
	animation_player.play("Idle")
	
func state_process(_delta: float) -> void:
	var is_running = Input.is_action_pressed("CorrerP1")
	var is_crouching = Input.is_action_pressed("AbajoP1")
	var is_rolling = Input.is_action_just_pressed("AbajoP1")
	
	if not father.is_on_floor():
		next_state = jump_state
		return
		
	if not is_zero_approx(father.velocity.x):
		if is_running and is_rolling:
			next_state = plancha_state
			return
		elif is_running:
			next_state = run_state
			return
		else:
			if is_rolling:
				next_state = roll_state
				return
			else: 
				next_state = walk_state
				return
	else:
		if is_crouching:
			next_state = crouch_state
			return
		
