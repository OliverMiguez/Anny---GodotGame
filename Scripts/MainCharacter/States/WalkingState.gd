extends "res://Scripts/GeneralStates/Util/State.gd"

@export var idle_state:State
@export var run_state:State
@export var jump_state:State
@export var roll_state:State
@export var shoot_state:State

func on_enter():
	animation_player.play("Walk")

func state_process(_delta: float) -> void:
	if father.velocity.x == 0: 
		next_state = idle_state
		
