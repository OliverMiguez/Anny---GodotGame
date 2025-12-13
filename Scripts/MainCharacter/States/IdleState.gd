extends "res://Scripts/GeneralStates/Util/State.gd"

@export var walk_state:State
@export var run_state:State
@export var crouch_state:State
@export var jump_state:State

func on_enter():
	animation_player.play("Idle")
	

func state_process(_delta: float) -> void:
	if father.velocity.x != 0 and Input.is_action_pressed("Shift"):
		next_state = run_state
		
	elif father.velocity.x!=0:
		next_state = walk_state
	
	elif father.velocity.x == 0 and Input.is_action_pressed("ui_down"):
		next_state = crouch_state
	
	elif father.velocity.y != 0:
		next_state = jump_state
	
