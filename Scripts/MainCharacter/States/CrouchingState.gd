extends "res://Scripts/GeneralStates/Util/State.gd"


@export var walk_state:State
@export var run_state:State
@export var jump_state:State

func on_enter():
	animation_player.play("Crouch")

func state_process(_delta: float) -> void:
	if father.velocity.x != 0 and Input.is_action_pressed("Shift"):
		next_state = run_state
		
	elif father.velocity.x!=0:
		next_state=walk_state
		
	elif Input.is_action_pressed("ui_up"):
		next_state = jump_state
