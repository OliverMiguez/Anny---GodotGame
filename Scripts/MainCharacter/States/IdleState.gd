extends "res://Scripts/GeneralStates/Util/State.gd"

@export var walk_state:State
@export var run_state:State
@export var crouch_state:State
@export var jump_state:State
@export var shoot_state:State

func on_enter():
	animation_player.play("Idle")
	
func state_process(_delta: float) -> void:
	if father.velocity.x != 0:
		next_state = walk_state
	
